#!/usr/bin/env bash
#
# add-unit.sh — add a new unit to an existing agency or unit.
#
# Invoked by the silcrow:silcrow-add-unit skill. Creates the unit's directory
# nested inside the parent unit, scaffolds its flat structure (1 | Canon,
# 2 | Working Files, agent dirs, README per §0012), and writes an establishing
# ADR into the parent's `1 | Canon/accepted/`.
#
# Sub-units inherit `3 | Silcrow Agency Reference` from the agency root
# (§0012) — that folder is root-only.
#
# The skill figures out all values through conversation; this script does the
# mechanical work.
#
# Usage:
#   add-unit.sh <parent_path> <unit_name> <unit_purpose> \
#               <lead_role> <implementer_role> \
#               --agency-name <agency_name> \
#               [--user-role <user_role>] \
#               [--parent-lead-role <parent_lead_role>] \
#               [--skip-commit]
#
# Arguments:
#   parent_path         Absolute path to the parent unit's directory (its
#                       basename must start with `@ `, e.g.
#                       /path/to/@ Pebble/). The new sub-unit will be created
#                       nested inside this directory as a sibling of the
#                       parent's agents and governance folders.
#   unit_name           Title-case unit name (without `@` prefix); the
#                       directory will be named `@ <unit_name>/`.
#   unit_purpose        One-sentence description of what the unit owns.
#   lead_role           Display name for the unit's Lead (e.g. "Lead",
#                       "Director").
#   implementer_role    Display name for the unit's Implementer (e.g.
#                       "Implementer", "Specialist").
#
# Required options:
#   --agency-name       Display name of the agency this unit belongs to.
#                       Used in the establishing ADR's prose, the unit-level
#                       README, and inherited references like
#                       `@ <agency_name>/3 | Silcrow Agency Reference/`.
#                       The caller (the silcrow-add-unit skill) reads this
#                       from the parent unit's `silcrow-meta` README anchor.
#
# Optional options:
#   --user-role         Display name of the agency's user role (default: User).
#                       Used in the establishing ADR's prose for references
#                       like "route through the User."
#   --parent-lead-role  Display name of the parent unit's Lead role (default:
#                       Lead). Used in the establishing ADR's prose for
#                       references like "reports up to the parent Lead."
#   --skip-commit       Skip the governance commit after creating the unit.
#
# Exit codes:
#   0   Success.
#   1   Plugin scaffold source not found.
#   2   Argument error (including missing --agency-name).
#   3   Parent unit not found (basename doesn't start with `@`).
#   4   Unit already exists at parent_path/`@ <unit_name>`/.

set -euo pipefail

# --- Argument parsing --------------------------------------------------------

SKIP_COMMIT=0
USER_ROLE_ARG="User"
PARENT_LEAD_ROLE_ARG="Lead"
AGENCY_NAME_ARG=""
PARENT_UNIT_NAME_ARG=""
POSITIONAL=()

while [ "$#" -gt 0 ]; do
    case "$1" in
        --skip-commit)
            SKIP_COMMIT=1
            shift
            ;;
        --user-role)
            USER_ROLE_ARG="$2"
            shift 2
            ;;
        --parent-lead-role)
            PARENT_LEAD_ROLE_ARG="$2"
            shift 2
            ;;
        --agency-name)
            AGENCY_NAME_ARG="$2"
            shift 2
            ;;
        --parent-unit-name)
            PARENT_UNIT_NAME_ARG="$2"
            shift 2
            ;;
        -*)
            echo "Error: unknown option '$1'" >&2
            exit 2
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done

if [ "${#POSITIONAL[@]}" -ne 5 ]; then
    cat >&2 <<'USAGE'
Usage: add-unit.sh <parent_path> <unit_name> <unit_purpose> \
                   <lead_role> <implementer_role> \
                   [--skip-commit]
USAGE
    exit 2
fi

PARENT_PATH="${POSITIONAL[0]}"
UNIT_NAME="${POSITIONAL[1]}"
UNIT_PURPOSE="${POSITIONAL[2]}"
LEAD_ROLE="${POSITIONAL[3]}"
IMPL_ROLE="${POSITIONAL[4]}"
DATE="$(date -u +%Y-%m-%d)"

# --- Helper: detect if a directory IS a unit (basename starts with @) ----
#
# Used once to validate PARENT_PATH. The script never inspects PARENT_PATH's
# parent or any ancestor — all extra-CWD facts (agency name, user role,
# parent lead role) come in as explicit flags from the caller.

is_unit_dir() {
    local dir="$1"
    local base
    base="$(basename "$dir")"
    case "$base" in
        @*) return 0 ;;
        *)  return 1 ;;
    esac
}

# --- Resolve AGENCY_NAME (required from caller) ------------------------------

if [ -z "$AGENCY_NAME_ARG" ]; then
    echo "Error: --agency-name is required." >&2
    echo "The skill reads it from the parent unit's silcrow-meta README anchor and passes it explicitly." >&2
    exit 2
fi
AGENCY_NAME="$AGENCY_NAME_ARG"

# --- Compute parent unit's name from PARENT_PATH basename --------------------
#
# PARENT_PATH is the parent unit's own directory; its basename is `@ <Name>/`,
# so PARENT_UNIT_NAME is the basename minus the `@ ` prefix.

if [ -n "$PARENT_UNIT_NAME_ARG" ]; then
    PARENT_UNIT_NAME="$PARENT_UNIT_NAME_ARG"
else
    PARENT_BASENAME="$(basename "$PARENT_PATH")"
    PARENT_UNIT_NAME="${PARENT_BASENAME#@ }"
fi

# --- Locate plugin scaffold source (for Establish Unit template) -------------

if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
    PLUGIN_ROOT="$CLAUDE_PLUGIN_ROOT"
else
    SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    PLUGIN_ROOT="$( dirname "$SCRIPT_DIR" )"
fi

ESTABLISH_TEMPLATE="$PLUGIN_ROOT/scaffold/unit/1 | Canon/_templates/Establish Unit.md"

if [ ! -f "$ESTABLISH_TEMPLATE" ]; then
    echo "Error: Establish Unit template not found at $ESTABLISH_TEMPLATE" >&2
    exit 1
fi

# --- Verify PARENT_PATH itself is a unit (basename starts with @) ------------

if ! is_unit_dir "$PARENT_PATH"; then
    echo "Error: parent path '$PARENT_PATH' is not a unit directory (basename must start with @)." >&2
    echo "Run :silcrow-init first to scaffold the agency, or navigate to an existing unit's directory." >&2
    exit 3
fi

# --- Verify the unit doesn't already exist -----------------------------------

UNIT_PATH="$PARENT_PATH/@ $UNIT_NAME"

if [ -e "$UNIT_PATH" ]; then
    echo "Error: unit already exists at $UNIT_PATH." >&2
    echo "Choose a different unit name or remove the existing directory first." >&2
    exit 4
fi

# --- Determine the next §-number for the establishing ADR --------------------

# Look at the parent unit's `1 | Canon/accepted/` and find the highest §NNNN.
# §-numbers live in filenames like `§NNNN | Title.md`. Parse the §NNNN portion
# by splitting on whitespace (the pipe separator is preceded by a space).
PARENT_CANON="$PARENT_PATH/1 | Canon"
ACCEPTED_DIR="$PARENT_CANON/accepted"

HIGHEST=0
parse_section() {
    # Given a path to an ADR file, echo its §-number as an integer (no leading
    # zeros). Filenames are `§NNNN | Title.md`; strip everything after the
    # first whitespace to isolate the §NNNN, then strip the §, then 10#NNNN
    # to convert to integer (avoiding bash's octal interpretation).
    local f="$1"
    local name num_part
    name=$(basename "$f")
    # Take everything before the first whitespace.
    num_part="${name%% *}"
    # Strip the leading §.
    num_part="${num_part#§}"
    # Convert to base-10 integer.
    echo $((10#$num_part))
}

if [ -d "$ACCEPTED_DIR" ]; then
    for f in "$ACCEPTED_DIR"/§*.md; do
        [ -f "$f" ] || continue
        num=$(parse_section "$f")
        if [ "$num" -gt "$HIGHEST" ]; then
            HIGHEST=$num
        fi
    done
fi

# Also check superseded/ and rejected/ — §-numbers are never reused.
for dir in "$PARENT_CANON/superseded" "$PARENT_CANON/rejected"; do
    if [ -d "$dir" ]; then
        for f in "$dir"/§*.md; do
            [ -f "$f" ] || continue
            num=$(parse_section "$f")
            if [ "$num" -gt "$HIGHEST" ]; then
                HIGHEST=$num
            fi
        done
    fi
done

NEXT_NUM=$((HIGHEST + 1))
NEXT_SECTION=$(printf "%04d" "$NEXT_NUM")

# --- Create the unit directory and scaffold its flat structure ---------------
#
# Per §0012's flat layout: agents and governance folders are direct children
# of `@ <Unit Name>/`. Agent dirs are `<Role> @ <Unit Name>/`. Governance
# folders are constants (`1 | Canon`, `2 | Working Files`) — no per-unit
# suffix. Sub-units inherit `3 | Silcrow Agency Reference` from the agency
# root; we don't ship it here.

mkdir -p \
    "$UNIT_PATH/$LEAD_ROLE @ $UNIT_NAME/inbox/archive" \
    "$UNIT_PATH/$IMPL_ROLE @ $UNIT_NAME/inbox/archive" \
    "$UNIT_PATH/Registrar @ $UNIT_NAME/inbox/archive" \
    "$UNIT_PATH/1 | Canon/_templates" \
    "$UNIT_PATH/1 | Canon/accepted" \
    "$UNIT_PATH/1 | Canon/proposed" \
    "$UNIT_PATH/1 | Canon/superseded" \
    "$UNIT_PATH/1 | Canon/rejected" \
    "$UNIT_PATH/2 | Working Files"

touch \
    "$UNIT_PATH/$LEAD_ROLE @ $UNIT_NAME/inbox/archive/.gitkeep" \
    "$UNIT_PATH/$IMPL_ROLE @ $UNIT_NAME/inbox/archive/.gitkeep" \
    "$UNIT_PATH/Registrar @ $UNIT_NAME/inbox/archive/.gitkeep" \
    "$UNIT_PATH/1 | Canon/accepted/.gitkeep" \
    "$UNIT_PATH/1 | Canon/proposed/.gitkeep" \
    "$UNIT_PATH/1 | Canon/superseded/.gitkeep" \
    "$UNIT_PATH/1 | Canon/rejected/.gitkeep"

# --- Unit-level README -------------------------------------------------------

cat > "$UNIT_PATH/README.md" <<README
<!-- silcrow-meta agency="$AGENCY_NAME" user-role="$USER_ROLE_ARG" lead-role="$LEAD_ROLE" implementer-role="$IMPL_ROLE" -->

# @ $UNIT_NAME

$UNIT_PURPOSE

\`@ $UNIT_NAME\` is a **unit** in the agency \`@ $AGENCY_NAME\`'s tree, nested
inside its parent unit \`@ $PARENT_UNIT_NAME\`. Per §0012, every unit follows
the same flat layout: \`1 | Canon/\` for decisions, \`2 | Working Files/\` for
operational artifacts, agent directories alongside, and any sub-units as
siblings. \`3 | Silcrow Agency Reference/\` lives only at the agency's root
and is inherited.

---

## Inheritance up the tree

\`@ $UNIT_NAME\` is bound by every ancestor unit's ADRs:

- The agency's root unit's \`@ $AGENCY_NAME/1 | Canon/accepted/\` (§0001
  through whatever the root has authored).
- Any intermediate parent units' \`1 | Canon/accepted/\` (when nested
  deeper than one level).

\`@ $UNIT_NAME\`'s own \`1 | Canon/accepted/\` holds only decisions
specific to this unit, narrower than (or unrelated to) what the ancestors
already cover.

For foundational process docs — \`Philosophy.md\`, \`Decision Process.md\`,
\`Message Protocol.md\`, \`foundations/\`, the registrar checklists — see the
agency's root unit's \`@ $AGENCY_NAME/3 | Silcrow Agency Reference/\`.
That folder is root-only and inherited by every unit; sub-units do not
duplicate it.

---

## This unit's roles

- **$LEAD_ROLE @ $UNIT_NAME** (\`$LEAD_ROLE @ $UNIT_NAME/\`) — tier-1 of
  \`@ $UNIT_NAME\`; reports up the tree to the Lead of the parent unit
  \`@ $PARENT_UNIT_NAME\`.
- **$IMPL_ROLE @ $UNIT_NAME** (\`$IMPL_ROLE @ $UNIT_NAME/\`) — tier-2 of
  \`@ $UNIT_NAME\`; reports to $LEAD_ROLE @ $UNIT_NAME.
- **Registrar @ $UNIT_NAME** (\`Registrar @ $UNIT_NAME/\`) — audits
  \`@ $UNIT_NAME\`'s record. Outside the unit's decision hierarchy.

There is no User at this unit. There is one User across the agency, who is
the principal of every unit and lives at the agency's root unit
(\`@ $AGENCY_NAME\`) (§0010).

---

## Establishing ADR

\`@ $UNIT_NAME\` was established by \`§$NEXT_SECTION\` in
\`@ $PARENT_UNIT_NAME\`'s \`1 | Canon/accepted/\`. Read it for the
unit's scope and original reasoning.
README

# --- Working Files README pointer for sub-unit -------------------------------

cat > "$UNIT_PATH/2 | Working Files/README.md" <<README
# 2 | Working Files — @ $UNIT_NAME

\`2 | Working Files/\` is this unit's operational catch-all — code, deliverables,
shared work product, anything that isn't governance and isn't private to a
single agent. See the agency's
\`@ $AGENCY_NAME/2 | Working Files/README.md\` for the operational-container
conventions every unit shares.
README

# --- Unit-level agent instructions -------------------------------------------
#
# Each agent directory gets only AGENTS.md — the universal cross-tool
# convention, auto-loaded by Claude Code natively. Every unit in the agency
# is structurally identical (§0012), so we use the same templates as the root
# unit with this unit's values substituted.

TEMPLATE_LEAD="$PLUGIN_ROOT/scaffold/unit/Lead/AGENTS.md"
TEMPLATE_IMPL="$PLUGIN_ROOT/scaffold/unit/Implementer/AGENTS.md"
TEMPLATE_REG="$PLUGIN_ROOT/scaffold/unit/Registrar/AGENTS.md"

for tmpl in "$TEMPLATE_LEAD" "$TEMPLATE_IMPL" "$TEMPLATE_REG"; do
    if [ ! -f "$tmpl" ]; then
        echo "Error: agent template not found at $tmpl" >&2
        echo "The plugin may not be installed correctly." >&2
        exit 1
    fi
done

subst() {
    local src="$1"
    local dst="$2"
    local an_esc="${AGENCY_NAME//|/\\|}"
    local un_esc="${UNIT_NAME//|/\\|}"
    sed \
        -e "s|{agency_name}|$an_esc|g" \
        -e "s|{unit_name}|$un_esc|g" \
        -e "s|{user_role}|$USER_ROLE_ARG|g" \
        -e "s|{lead_role}|$LEAD_ROLE|g" \
        -e "s|{implementer_role}|$IMPL_ROLE|g" \
        -e "s|{date}|$DATE|g" \
        "$src" > "$dst"
}

subst "$TEMPLATE_LEAD" "$UNIT_PATH/$LEAD_ROLE @ $UNIT_NAME/AGENTS.md"
subst "$TEMPLATE_IMPL" "$UNIT_PATH/$IMPL_ROLE @ $UNIT_NAME/AGENTS.md"
subst "$TEMPLATE_REG"  "$UNIT_PATH/Registrar @ $UNIT_NAME/AGENTS.md"

# --- Render the establishing ADR ---------------------------------------------

ADR_FILE="$ACCEPTED_DIR/§$NEXT_SECTION | Establish Unit @ $UNIT_NAME.md"

un_esc="${UNIT_NAME//|/\\|}"
up_esc="${UNIT_PURPOSE//|/\\|}"
an_esc="${AGENCY_NAME//|/\\|}"
pun_esc="${PARENT_UNIT_NAME//|/\\|}"

PARENT_LEAD_ROLE="${PARENT_LEAD_ROLE_ARG:-Lead}"

sed \
    -e "s|§NNNN|§$NEXT_SECTION|g" \
    -e "s|{unit_name}|$un_esc|g" \
    -e "s|{date}|$DATE|g" \
    -e "s|{one_sentence_purpose}|$up_esc|g" \
    -e "s|{user_role}|$USER_ROLE_ARG|g" \
    -e "s|{lead_role}|$LEAD_ROLE|g" \
    -e "s|{implementer_role}|$IMPL_ROLE|g" \
    -e "s|{parent_lead_role}|$PARENT_LEAD_ROLE|g" \
    -e "s|{parent_unit_name}|$pun_esc|g" \
    -e "s|{agency_name}|$an_esc|g" \
    -e "s|{parent_path}|@ $PARENT_UNIT_NAME|g" \
    -e "s|{authoring_lead_or_user}|Lead or User|g" \
    "$ESTABLISH_TEMPLATE" > "$ADR_FILE"

# --- Update the ADR index (parent's `1 | Canon/README.md`) -------------------
#
# Append a hint at the end of the index. The Registrar's audit normalizes
# this into the proper Accepted-table row on next run.

INDEX="$PARENT_CANON/README.md"
if [ -f "$INDEX" ]; then
    cat >> "$INDEX" <<INDEX_NOTE

<!-- §$NEXT_SECTION auto-added by :silcrow-add-unit on $DATE; Registrar: incorporate into Accepted table. -->
INDEX_NOTE
fi

# --- Git commit (§0015 convention) -------------------------------------------

if [ "$SKIP_COMMIT" -eq 0 ]; then
    if (cd "$PARENT_PATH" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        (cd "$PARENT_PATH" && \
            git add . && \
            git commit --quiet -m "§$NEXT_SECTION: establish unit @ $UNIT_NAME")
    fi
fi

# --- Success output ----------------------------------------------------------

cat <<SUMMARY
✓ Added unit @ $UNIT_NAME at $UNIT_PATH
  Purpose: $UNIT_PURPOSE
  Roles:   $LEAD_ROLE, $IMPL_ROLE, Registrar
  Parent:  $PARENT_PATH
  Registering ADR: $ADR_FILE
SUMMARY
