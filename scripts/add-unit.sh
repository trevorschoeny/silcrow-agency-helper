#!/usr/bin/env bash
#
# add-unit.sh — add a new unit to an existing agency or unit.
#
# Invoked by the silcrow:silcrow-add-unit skill. Creates the unit's directory,
# populates its #ORG@<unit-name>/ governance folder, and writes an establishing
# ADR into the parent's #ORG@<parent-unit-name>/adr/accepted/.
#
# The skill figures out all values through conversation; this script does the
# mechanical work.
#
# Usage:
#   add-unit.sh <parent_path> <unit_name> <unit_purpose> \
#               <lead_dir> <lead_role> \
#               <implementer_dir> <implementer_role> \
#               [--mode directory|submodule] \
#               [--submodule-source <url_or_path>] \
#               [--skip-commit]
#
# Arguments:
#   parent_path         Absolute path to the parent unit (must contain #ORG@*/).
#   unit_name           Kebab-case unit name (without @ prefix); the directory
#                       will be named @<unit_name>/.
#   unit_purpose        One-sentence description of what the unit owns.
#   lead_dir            Directory name for the unit's Lead.
#   lead_role           Display name for the unit's Lead role.
#   implementer_dir     Directory name for the unit's Implementer.
#   implementer_role    Display name for the unit's Implementer role.
#
# Options:
#   --mode              "directory" (default) or "submodule".
#   --submodule-source  Remote URL or local path when --mode=submodule. If
#                       omitted with --mode=submodule, initializes a fresh
#                       local repo inside the unit.
#   --skip-commit       Skip the governance commit after creating the unit.
#
# Exit codes:
#   0   Success.
#   1   Plugin scaffold source not found.
#   2   Argument error.
#   3   Parent unit not found (no #ORG@*/ in parent_path).
#   4   Unit already exists at parent_path/@<unit_name>/.

set -euo pipefail

# --- Argument parsing --------------------------------------------------------

MODE="directory"
SUBMODULE_SOURCE=""
SKIP_COMMIT=0
USER_ROLE_ARG="User"
USER_DIR_ARG="user"
PARENT_LEAD_ROLE_ARG="Lead"
AGENCY_DIR_ARG=""
AGENCY_NAME_ARG=""
PARENT_UNIT_NAME_ARG=""
PARENT_UNIT_DISPLAY_ARG=""
UNIT_DISPLAY_ARG=""
POSITIONAL=()

while [ "$#" -gt 0 ]; do
    case "$1" in
        --mode)
            MODE="$2"
            shift 2
            ;;
        --submodule-source)
            SUBMODULE_SOURCE="$2"
            shift 2
            ;;
        --skip-commit)
            SKIP_COMMIT=1
            shift
            ;;
        --user-role)
            USER_ROLE_ARG="$2"
            shift 2
            ;;
        --user-dir)
            USER_DIR_ARG="$2"
            shift 2
            ;;
        --parent-lead-role)
            PARENT_LEAD_ROLE_ARG="$2"
            shift 2
            ;;
        --agency-dir)
            AGENCY_DIR_ARG="$2"
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
        --parent-unit-display)
            PARENT_UNIT_DISPLAY_ARG="$2"
            shift 2
            ;;
        --unit-display)
            UNIT_DISPLAY_ARG="$2"
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

if [ "${#POSITIONAL[@]}" -ne 7 ]; then
    cat >&2 <<'USAGE'
Usage: add-unit.sh <parent_path> <unit_name> <unit_purpose> \
                   <lead_dir> <lead_role> \
                   <implementer_dir> <implementer_role> \
                   [--mode directory|submodule] \
                   [--submodule-source <url_or_path>] \
                   [--skip-commit]
USAGE
    exit 2
fi

PARENT_PATH="${POSITIONAL[0]}"
UNIT_NAME="${POSITIONAL[1]}"
UNIT_PURPOSE="${POSITIONAL[2]}"
LEAD_DIR="${POSITIONAL[3]}"
LEAD_ROLE="${POSITIONAL[4]}"
IMPL_DIR="${POSITIONAL[5]}"
IMPL_ROLE="${POSITIONAL[6]}"
DATE="$(date -u +%Y-%m-%d)"

# --- Helper: detect if a directory is a unit (has any #ORG@*/ subdir) --------

has_org_marker() {
    local dir="$1"
    local d
    for d in "$dir"/#ORG@*; do
        [ -d "$d" ] && return 0
    done
    return 1
}

# --- Resolve AGENCY_DIR (auto-walk up if not supplied) -----------------------

# The agency root is the outermost ancestor of PARENT_PATH that still contains
# a #ORG@*/ directory. Walk up until the parent isn't a unit — the last
# unit-having directory is the agency's root unit.
if [ -z "$AGENCY_DIR_ARG" ]; then
    walker="$PARENT_PATH"
    while has_org_marker "$(dirname "$walker")"; do
        walker="$(dirname "$walker")"
    done
    AGENCY_BASENAME="$(basename "$walker")"
    AGENCY_DIR="${AGENCY_BASENAME#@}"
else
    AGENCY_DIR="$AGENCY_DIR_ARG"
fi
AGENCY_NAME="${AGENCY_NAME_ARG:-$AGENCY_DIR}"

# --- Compute UNIT_DISPLAY (default: title-case the kebab unit_name) ----------

# Bash 3-compatible title-case helper.
to_title_case() {
    local kebab="$1"
    local result=""
    local IFS='-'
    read -ra parts <<< "$kebab"
    for word in "${parts[@]}"; do
        local first="${word:0:1}"
        local rest="${word:1}"
        local first_up
        first_up=$(echo "$first" | tr '[:lower:]' '[:upper:]')
        result+="$first_up$rest "
    done
    echo "${result% }"
}

UNIT_DISPLAY="${UNIT_DISPLAY_ARG:-$(to_title_case "$UNIT_NAME")}"

# --- Compute parent unit's slug + display (default: derive from PARENT_PATH) -

# If the skill passed --parent-unit-name explicitly, use it. Otherwise infer
# from the basename of PARENT_PATH (strip leading @). Same for display.
if [ -n "$PARENT_UNIT_NAME_ARG" ]; then
    PARENT_UNIT_NAME="$PARENT_UNIT_NAME_ARG"
else
    PARENT_BASENAME="$(basename "$PARENT_PATH")"
    PARENT_UNIT_NAME="${PARENT_BASENAME#@}"
fi
PARENT_UNIT_DISPLAY="${PARENT_UNIT_DISPLAY_ARG:-$(to_title_case "$PARENT_UNIT_NAME")}"

# Validate MODE
case "$MODE" in
    directory|submodule) ;;
    *)
        echo "Error: --mode must be 'directory' or 'submodule', got '$MODE'" >&2
        exit 2
        ;;
esac

# --- Locate plugin scaffold source (for establish-unit template) -------------

if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
    PLUGIN_ROOT="$CLAUDE_PLUGIN_ROOT"
else
    SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    PLUGIN_ROOT="$( dirname "$SCRIPT_DIR" )"
fi

ESTABLISH_TEMPLATE="$PLUGIN_ROOT/scaffold/#ORG/adr/_templates/establish-unit.md"

if [ ! -f "$ESTABLISH_TEMPLATE" ]; then
    echo "Error: establish-unit template not found at $ESTABLISH_TEMPLATE" >&2
    exit 1
fi

# --- Verify the parent is a unit (has #ORG@<parent-name>/) -------------------

if ! has_org_marker "$PARENT_PATH"; then
    echo "Error: parent path '$PARENT_PATH' does not contain a #ORG@*/ directory." >&2
    echo "Run :silcrow-init first to scaffold the agency, or navigate to an existing unit." >&2
    exit 3
fi

# --- Verify the unit doesn't already exist -----------------------------------

UNIT_PATH="$PARENT_PATH/@$UNIT_NAME"

if [ -e "$UNIT_PATH" ]; then
    echo "Error: unit already exists at $UNIT_PATH." >&2
    echo "Choose a different unit name or remove the existing directory first." >&2
    exit 4
fi

# --- Determine the next §-number for the establishing ADR --------------------

# Look at the parent's #ORG@<parent-name>/adr/accepted/ and find the highest §NNNN.
# §-numbers live in filenames like §NNNN-title.md.
ACCEPTED_DIR="$PARENT_PATH/#ORG@$PARENT_UNIT_NAME/adr/accepted"

HIGHEST=0
if [ -d "$ACCEPTED_DIR" ]; then
    # Extract §NNNN prefixes, strip the §, compare as integers.
    # Use a safer approach: iterate filenames and parse the numeric portion.
    for f in "$ACCEPTED_DIR"/§*.md; do
        [ -f "$f" ] || continue
        # Extract the number after § and before the first -
        name=$(basename "$f")
        # Remove §, then take characters until the -
        num_part="${name#§}"
        num_part="${num_part%%-*}"
        # Strip leading zeros for comparison (bash interprets leading 0 as octal)
        num=$((10#$num_part))
        if [ "$num" -gt "$HIGHEST" ]; then
            HIGHEST=$num
        fi
    done
fi

# Also check superseded/ and rejected/ — §-numbers are never reused.
for dir in "$PARENT_PATH/#ORG@$PARENT_UNIT_NAME/adr/superseded" "$PARENT_PATH/#ORG@$PARENT_UNIT_NAME/adr/rejected"; do
    if [ -d "$dir" ]; then
        for f in "$dir"/§*.md; do
            [ -f "$f" ] || continue
            name=$(basename "$f")
            num_part="${name#§}"
            num_part="${num_part%%-*}"
            num=$((10#$num_part))
            if [ "$num" -gt "$HIGHEST" ]; then
                HIGHEST=$num
            fi
        done
    fi
done

NEXT_NUM=$((HIGHEST + 1))
# Zero-pad to four digits.
NEXT_SECTION=$(printf "%04d" "$NEXT_NUM")

# --- Create the unit directory -----------------------------------------------

# For submodule mode with a remote source, use `git submodule add`.
# For submodule mode with no source or local source, initialize as a plain
# directory first and then optionally run `git submodule add` after scaffolding.
# For directory mode, just mkdir.

if [ "$MODE" = "submodule" ] && [ -n "$SUBMODULE_SOURCE" ]; then
    # Attempt to add as submodule. This requires parent to be a git repo.
    if ! (cd "$PARENT_PATH" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        echo "Error: --mode=submodule with a source requires parent to be a git repo." >&2
        exit 3
    fi
    (cd "$PARENT_PATH" && git submodule add --quiet "$SUBMODULE_SOURCE" "@$UNIT_NAME")
else
    mkdir -p "$UNIT_PATH"
fi

# --- Scaffold the unit's #ORG@<unit-name>/ -----------------------------------

# Per §0014's agent-identity convention, every agent's directory is named
# <role-dir>@<unit-name>/. At this unit, that means lead@$UNIT_NAME, etc.
mkdir -p \
    "$UNIT_PATH/#ORG@$UNIT_NAME/agents/$LEAD_DIR@$UNIT_NAME/inbox/archive" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/agents/$IMPL_DIR@$UNIT_NAME/inbox/archive" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/agents/registrar@$UNIT_NAME/inbox/archive" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/accepted" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/proposed" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/superseded" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/rejected" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/anti-patterns" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/docs"

touch \
    "$UNIT_PATH/#ORG@$UNIT_NAME/agents/$LEAD_DIR@$UNIT_NAME/inbox/archive/.gitkeep" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/agents/$IMPL_DIR@$UNIT_NAME/inbox/archive/.gitkeep" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/agents/registrar@$UNIT_NAME/inbox/archive/.gitkeep" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/accepted/.gitkeep" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/proposed/.gitkeep" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/superseded/.gitkeep" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/rejected/.gitkeep" \
    "$UNIT_PATH/#ORG@$UNIT_NAME/adr/anti-patterns/.gitkeep"

# --- Unit-level README files -------------------------------------------------

cat > "$UNIT_PATH/#ORG@$UNIT_NAME/README.md" <<README
# @$UNIT_NAME

$UNIT_PURPOSE

\`@$UNIT_NAME\` is a **unit** in the agency \`@$AGENCY_DIR\`'s tree, sitting as
a child of \`@$PARENT_UNIT_NAME\`. Governance for this unit lives here
(\`#ORG@$UNIT_NAME/\`); operational work lives alongside it in this unit's
root directory.

Every unit in the agency is structurally identical (§0014) — the root unit and
every sub-unit follow the same conventions. \`@$UNIT_NAME\`'s position in the
tree is what makes it a sub-unit; the rules are the same as anywhere else.

---

## Inheritance up the tree

\`@$UNIT_NAME\` is bound by every ancestor unit's ADRs:

- The agency's root unit's \`#ORG@$AGENCY_DIR/adr/accepted/\` (§0001 through
  whatever the root has authored).
- Any intermediate parent units' \`#ORG@<parent-name>/adr/accepted/\` (when
  nested deeper than one level).

\`@$UNIT_NAME\`'s own \`#ORG@$UNIT_NAME/adr/accepted/\` holds only decisions
specific to this unit, narrower than (or unrelated to) what the ancestors
already cover.

For foundational process docs — \`philosophy.md\`, \`decision-process.md\`,
\`message-protocol.md\`, \`foundations/\`, the registrar checklists — see the
agency's root unit's \`#ORG@$AGENCY_DIR/docs/\`. Those docs live only at the
root and are inherited by every unit. This unit does not duplicate that
content.

---

## This unit's roles

- **$LEAD_ROLE @ $UNIT_DISPLAY** (\`#ORG@$UNIT_NAME/agents/$LEAD_DIR@$UNIT_NAME/\`)
  — tier-1 of \`@$UNIT_NAME\`; reports up the tree to the Lead of the parent
  unit \`@$PARENT_UNIT_NAME\`.
- **$IMPL_ROLE @ $UNIT_DISPLAY** (\`#ORG@$UNIT_NAME/agents/$IMPL_DIR@$UNIT_NAME/\`)
  — tier-2 of \`@$UNIT_NAME\`; reports to $LEAD_ROLE @ $UNIT_DISPLAY.
- **Registrar @ $UNIT_DISPLAY** (\`#ORG@$UNIT_NAME/agents/registrar@$UNIT_NAME/\`)
  — audits \`@$UNIT_NAME\`'s record. Outside the unit's decision hierarchy.

There is no User at this unit. There is one User across the agency, who is
the principal of every unit and lives at the agency's root unit
(\`@$AGENCY_DIR\`) (§0012).

---

## Establishing ADR

\`@$UNIT_NAME\` was established by \`§$NEXT_SECTION\` in
\`@$PARENT_UNIT_NAME\`'s \`#ORG@$PARENT_UNIT_NAME/adr/accepted/\`. Read it for
the unit's scope and original reasoning.
README

cat > "$UNIT_PATH/#ORG@$UNIT_NAME/docs/README.md" <<README
# @$UNIT_NAME docs

\`@$UNIT_NAME\` inherits foundational documentation from the agency's root unit
(\`@$AGENCY_DIR\`'s \`#ORG@$AGENCY_DIR/docs/\`). Decision process, message
protocol, philosophy, foundations, and registrar playbook all live there.

This folder exists for documentation specific to \`@$UNIT_NAME\` — onboarding
notes, process addenda, unit-internal references. It starts empty and fills
only with content genuinely specific to this unit.
README

# --- Unit-level agent instructions -------------------------------------------

# Each agent directory gets two files: AGENTS.md (canonical content, auto-loaded
# by cross-tool agents) and CLAUDE.md (one-line `@AGENTS.md` pointer that Claude
# Code auto-loads and imports). Every unit in the agency is structurally
# identical (§0014), so we use the same templates as the root unit with this
# unit's values substituted — no thin-preamble asymmetry between root and
# sub-unit Leads/Implementers/Registrars.

# Locate the templates (shared with scaffold.sh).
TEMPLATE_LEAD="$PLUGIN_ROOT/scaffold/#ORG/agents/lead/AGENTS.md"
TEMPLATE_IMPL="$PLUGIN_ROOT/scaffold/#ORG/agents/implementer/AGENTS.md"
TEMPLATE_REG="$PLUGIN_ROOT/scaffold/#ORG/agents/registrar/AGENTS.md"

for tmpl in "$TEMPLATE_LEAD" "$TEMPLATE_IMPL" "$TEMPLATE_REG"; do
    if [ ! -f "$tmpl" ]; then
        echo "Error: agent template not found at $tmpl" >&2
        echo "The plugin may not be installed correctly." >&2
        exit 1
    fi
done

# Substitute placeholders into a template file. Same placeholder set as
# scaffold.sh's subst(), but with this unit's values rather than the agency
# root's. The User template is not installed at sub-units (one User per agency,
# at the root only).
subst() {
    local src="$1"
    local dst="$2"
    local an_esc="${AGENCY_NAME//|/\\|}"
    local ud_esc="${UNIT_DISPLAY//|/\\|}"
    sed \
        -e "s|{agency_name}|$an_esc|g" \
        -e "s|{agency_dir}|$AGENCY_DIR|g" \
        -e "s|{unit_name}|$UNIT_NAME|g" \
        -e "s|{unit_display}|$ud_esc|g" \
        -e "s|{user_dir}|$USER_DIR_ARG|g" \
        -e "s|{user_role}|$USER_ROLE_ARG|g" \
        -e "s|{lead_dir}|$LEAD_DIR|g" \
        -e "s|{lead_role}|$LEAD_ROLE|g" \
        -e "s|{implementer_dir}|$IMPL_DIR|g" \
        -e "s|{implementer_role}|$IMPL_ROLE|g" \
        -e "s|{date}|$DATE|g" \
        "$src" > "$dst"
}

subst "$TEMPLATE_LEAD" "$UNIT_PATH/#ORG@$UNIT_NAME/agents/$LEAD_DIR@$UNIT_NAME/AGENTS.md"
subst "$TEMPLATE_IMPL" "$UNIT_PATH/#ORG@$UNIT_NAME/agents/$IMPL_DIR@$UNIT_NAME/AGENTS.md"
subst "$TEMPLATE_REG"  "$UNIT_PATH/#ORG@$UNIT_NAME/agents/registrar@$UNIT_NAME/AGENTS.md"

# Write CLAUDE.md pointers alongside each AGENTS.md so Claude Code auto-loads.
for dir in "$LEAD_DIR@$UNIT_NAME" "$IMPL_DIR@$UNIT_NAME" "registrar@$UNIT_NAME"; do
    printf '@AGENTS.md\n' > "$UNIT_PATH/#ORG@$UNIT_NAME/agents/$dir/CLAUDE.md"
done

# --- Render the establishing ADR ---------------------------------------------

# We use simple sed substitution on the template. The template has many more
# placeholders than we have values — those remain as unfilled curly-brace
# tokens. The Lead can edit the ADR to fill them in, or the skill's
# conversation phase can gather more and pass them in (future enhancement).

ADR_FILE="$ACCEPTED_DIR/§$NEXT_SECTION-establish-unit-$UNIT_NAME.md"

# Escape | for sed delimiter safety.
un_esc="${UNIT_NAME//|/\\|}"
up_esc="${UNIT_PURPOSE//|/\\|}"
ud_esc="${UNIT_DISPLAY//|/\\|}"
pud_esc="${PARENT_UNIT_DISPLAY//|/\\|}"
an_esc="${AGENCY_NAME//|/\\|}"

PARENT_LEAD_ROLE="${PARENT_LEAD_ROLE_ARG:-Lead}"

sed \
    -e "s|§NNNN|§$NEXT_SECTION|g" \
    -e "s|{unit_name}|$un_esc|g" \
    -e "s|{unit_display}|$ud_esc|g" \
    -e "s|{date}|$DATE|g" \
    -e "s|{one_sentence_purpose}|$up_esc|g" \
    -e "s|{user_role}|$USER_ROLE_ARG|g" \
    -e "s|{lead_role}|$LEAD_ROLE|g" \
    -e "s|{implementer_role}|$IMPL_ROLE|g" \
    -e "s|{lead_dir}|$LEAD_DIR|g" \
    -e "s|{implementer_dir}|$IMPL_DIR|g" \
    -e "s|{Lead role name}|$LEAD_ROLE|g" \
    -e "s|{Implementer role name}|$IMPL_ROLE|g" \
    -e "s|{parent_lead_role}|$PARENT_LEAD_ROLE|g" \
    -e "s|{parent_unit_name}|$PARENT_UNIT_NAME|g" \
    -e "s|{parent_unit_display}|$pud_esc|g" \
    -e "s|{agency_dir}|$AGENCY_DIR|g" \
    -e "s|{agency_name}|$an_esc|g" \
    -e "s|{mode — directory \| submodule}|$MODE|g" \
    -e "s|{parent_path}|@$PARENT_UNIT_NAME|g" \
    -e "s|{authoring_lead_or_user}|Lead or User|g" \
    "$ESTABLISH_TEMPLATE" > "$ADR_FILE"

# Set the status to 'accepted' at the top.
# The template ships with "Status:** accepted" already — no change needed.

# --- Update the ADR index (parent's #ORG@<parent-name>/adr/README.md) --------

# Add a row to the Accepted table. We do a simple sed insertion after the last
# existing §-numbered row. This is best-effort; the Registrar's audit will
# repair the index if anything drifts.
#
# For reliability in this script, we simply append a single line to a known
# location. If the table structure has drifted, the Lead can fix it later.

INDEX="$PARENT_PATH/#ORG@$PARENT_UNIT_NAME/adr/README.md"
if [ -f "$INDEX" ]; then
    # Append a note at the end; Registrar can normalize on next audit.
    cat >> "$INDEX" <<INDEX_NOTE

<!-- §$NEXT_SECTION auto-added by :silcrow-add-unit on $DATE; Registrar: incorporate into Accepted table. -->
INDEX_NOTE
fi

# --- Git commit (§0017 convention) -------------------------------------------

if [ "$SKIP_COMMIT" -eq 0 ]; then
    if (cd "$PARENT_PATH" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        (cd "$PARENT_PATH" && \
            git add . && \
            git commit --quiet -m "§$NEXT_SECTION: establish unit @$UNIT_NAME")
    fi
fi

# --- Success output ----------------------------------------------------------

cat <<SUMMARY
✓ Added unit @$UNIT_NAME at $UNIT_PATH
  Purpose: $UNIT_PURPOSE
  Roles:   $LEAD_ROLE, $IMPL_ROLE, Registrar
  Parent:  $PARENT_PATH
  Mode:    $MODE
  Registering ADR: $ADR_FILE
SUMMARY
