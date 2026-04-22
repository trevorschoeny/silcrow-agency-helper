#!/usr/bin/env bash
#
# add-unit.sh — add a new unit to an existing agency or unit.
#
# Invoked by the agent-org-scaffold:add-unit skill. Creates the unit's directory,
# populates its #ORG/ governance folder, and writes an establishing ADR into the
# parent's #ORG/adr/accepted/.
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
#   parent_path         Absolute path to the parent unit (must contain #ORG/).
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
#   3   Parent unit not found (no #ORG/ in parent_path).
#   4   Unit already exists at parent_path/@<unit_name>/.

set -euo pipefail

# --- Argument parsing --------------------------------------------------------

MODE="directory"
SUBMODULE_SOURCE=""
SKIP_COMMIT=0
USER_ROLE_ARG="User"
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
        --parent-lead-role)
            PARENT_LEAD_ROLE_ARG="$2"
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

# --- Verify the parent has #ORG/ ---------------------------------------------

if [ ! -d "$PARENT_PATH/#ORG" ]; then
    echo "Error: parent path '$PARENT_PATH' does not contain #ORG/." >&2
    echo "Run :init first to scaffold the agency, or navigate to an existing unit." >&2
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

# Look at the parent's #ORG/adr/accepted/ and find the highest §NNNN.
# §-numbers live in filenames like §NNNN-title.md.
ACCEPTED_DIR="$PARENT_PATH/#ORG/adr/accepted"

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
for dir in "$PARENT_PATH/#ORG/adr/superseded" "$PARENT_PATH/#ORG/adr/rejected"; do
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

# --- Scaffold the unit's #ORG/ -----------------------------------------------

mkdir -p \
    "$UNIT_PATH/#ORG/agents/$LEAD_DIR/inbox/archive" \
    "$UNIT_PATH/#ORG/agents/$IMPL_DIR/inbox/archive" \
    "$UNIT_PATH/#ORG/agents/registrar/inbox/archive" \
    "$UNIT_PATH/#ORG/adr/accepted" \
    "$UNIT_PATH/#ORG/adr/proposed" \
    "$UNIT_PATH/#ORG/adr/superseded" \
    "$UNIT_PATH/#ORG/adr/rejected" \
    "$UNIT_PATH/#ORG/adr/anti-patterns" \
    "$UNIT_PATH/#ORG/docs"

touch \
    "$UNIT_PATH/#ORG/agents/$LEAD_DIR/inbox/archive/.gitkeep" \
    "$UNIT_PATH/#ORG/agents/$IMPL_DIR/inbox/archive/.gitkeep" \
    "$UNIT_PATH/#ORG/agents/registrar/inbox/archive/.gitkeep" \
    "$UNIT_PATH/#ORG/adr/accepted/.gitkeep" \
    "$UNIT_PATH/#ORG/adr/proposed/.gitkeep" \
    "$UNIT_PATH/#ORG/adr/superseded/.gitkeep" \
    "$UNIT_PATH/#ORG/adr/rejected/.gitkeep" \
    "$UNIT_PATH/#ORG/adr/anti-patterns/.gitkeep"

# --- Unit-level README files -------------------------------------------------

cat > "$UNIT_PATH/#ORG/README.md" <<README
# @$UNIT_NAME

$UNIT_PURPOSE

This is a **unit** within its parent agency. Governance for this unit lives here
(\`#ORG/\`); operational work lives alongside it in the unit's root directory.

---

## Inheritance from the agency

This unit is bound by all agency-level ADRs (§0001 through the current agency
record). You can find them in the parent's \`#ORG/adr/accepted/\`. This unit's
own \`#ORG/adr/accepted/\` holds only decisions specific to this unit.

For agency-level process (\`philosophy.md\`, \`decision-process.md\`,
\`message-protocol.md\`, foundations), see the agency's
\`#ORG/docs/\`. This unit does not duplicate that content.

---

## This unit's roles

- **$LEAD_ROLE** (\`#ORG/agents/$LEAD_DIR/\`) — tier-1 of @$UNIT_NAME;
  reports upward to the agency Lead.
- **$IMPL_ROLE** (\`#ORG/agents/$IMPL_DIR/\`) — tier-2 of @$UNIT_NAME.
- **Registrar** (\`#ORG/agents/registrar/\`) — audits this unit's record.

No User at unit level — the User is an agency-level role (§0013).

---

## Establishing ADR

This unit was established by \`§$NEXT_SECTION\` in the parent's
\`#ORG/adr/accepted/\`. Read it for the unit's scope and original reasoning.
README

cat > "$UNIT_PATH/#ORG/docs/README.md" <<README
# $UNIT_NAME docs

This unit inherits agency-level documentation from the agency's \`#ORG/docs/\`.
Decision process, message protocol, philosophy, foundations, and registrar
playbook all live there.

This folder exists for unit-specific documentation — onboarding notes, process
addenda, unit-internal references. It starts empty and fills only with content
genuinely specific to this unit.
README

# --- Unit-level agent instructions -------------------------------------------

# Each agent directory gets two files: AGENTS.md (canonical content, auto-loaded
# by cross-tool agents) and CLAUDE.md (one-line `@AGENTS.md` pointer that Claude
# Code auto-loads and imports). The AGENTS.md preamble is unit-specific; the
# agency's AGENTS.md carries the full role definition.

cat > "$UNIT_PATH/#ORG/agents/$LEAD_DIR/AGENTS.md" <<INSTR
# $LEAD_ROLE (unit: @$UNIT_NAME) — instructions

## Role identity

You are the $LEAD_ROLE for unit **@$UNIT_NAME**. The unit's purpose:
*$UNIT_PURPOSE*

You are **tier-1 of this unit** (§0013). You report upward to the agency's Lead
and inherit agency-level ADRs (§0001 through the current agency record).

## Read these first

- The agency's Lead AGENTS.md (walk up to the agency's root and look in
  \`#ORG/agents/<lead-dir>/AGENTS.md\`).
- The agency's §0013 for the multi-unit tier model.
- The agency's §0015 for unit structure and federation rules.
- This unit's establishing ADR (§NNNN) in the parent's
  \`#ORG/adr/accepted/\` for scope and reasoning behind this unit.

## How you differ from the agency Lead

- **Scope:** your authority covers @$UNIT_NAME only. Cross-unit decisions route
  through the agency Lead.
- **Reporting chain:** agency Lead upward; this unit's $IMPL_ROLE and this
  unit's Registrar alongside.
- **ADR scope:** ADRs you author live in \`#ORG/adr/accepted/\` (this unit's).
  Agency-level ADRs bind this unit automatically.
- **Federation (§0015):** you do not police peer units; peer units do not police
  this one.

## Inbox

Messages arrive in \`#ORG/agents/$LEAD_DIR/inbox/\` (this unit's).
Archive on read to \`#ORG/agents/$LEAD_DIR/inbox/archive/\`.

---

*For the full role definition — authorship authority, working pattern, canon/ops
discipline, git notes — refer to the agency's Lead AGENTS.md. The shape is
identical; only the scope is unit-level.*
INSTR

cat > "$UNIT_PATH/#ORG/agents/$IMPL_DIR/AGENTS.md" <<INSTR
# $IMPL_ROLE (unit: @$UNIT_NAME) — instructions

## Role identity

You are the $IMPL_ROLE for unit **@$UNIT_NAME**. The unit's purpose:
*$UNIT_PURPOSE*

You are **tier-2 of this unit** (§0013). You report to the unit's $LEAD_ROLE.

## Read these first

- The agency's Implementer AGENTS.md for the full role definition (walk up
  to the agency's \`#ORG/agents/<implementer-dir>/AGENTS.md\`).
- The agency's §0013 for the tier model and your draft-with-approval path.
- The agency's §0014 for the canon/operational split.
- This unit's establishing ADR for scope and reasoning.

## How you differ from the agency Implementer

- **Scope:** your work covers @$UNIT_NAME only.
- **Approval route:** drafts go to \`#ORG/adr/proposed/\` (this unit's), and
  approval comes from this unit's $LEAD_ROLE or from the User.

## Inbox

Messages arrive in \`#ORG/agents/$IMPL_DIR/inbox/\` (this unit's).
Archive on read to \`#ORG/agents/$IMPL_DIR/inbox/archive/\`.

---

*For the full role definition — working pattern, canon/ops promotion, raising
anti-patterns — refer to the agency's Implementer AGENTS.md. Shape identical;
scope is unit-level.*
INSTR

cat > "$UNIT_PATH/#ORG/agents/registrar/AGENTS.md" <<INSTR
# Registrar (unit: @$UNIT_NAME) — instructions

## Role identity

You are the Registrar for unit **@$UNIT_NAME**. You audit this unit's record
(the contents of \`#ORG/\` at this unit). Your authority is procedural only,
per §0012.

## Read these first

- The agency's Registrar AGENTS.md (walk up to the agency's
  \`#ORG/agents/registrar/AGENTS.md\`) for the full audit checklist,
  hybrid correction authority, and \`:update\` workflow orchestration.
- §0012 (async auditor mode).
- §0015 (federation rule — you do not audit peer units).
- This unit's establishing ADR for scope.

## How you differ from the agency Registrar

- **Scope:** you audit @$UNIT_NAME's \`#ORG/\` only. The agency Registrar audits
  the agency's \`#ORG/\` and unit↔ADR consistency at the agency level. You audit
  the internal integrity of this unit's record.
- **Federation (§0015):** if you notice issues in peer units, surface them to
  the agency Lead (not to the peer unit's Registrar directly, and not by
  auditing the peer unit's record).

## Inbox

Messages arrive in \`#ORG/agents/registrar/inbox/\` (this unit's).
Archive on read to \`#ORG/agents/registrar/inbox/archive/\`.

---

*For the full role definition — audit checklist, correction authority,
\`:update\` orchestration, git responsibilities — refer to the agency's
Registrar AGENTS.md. Shape identical; scope is unit-level.*
INSTR

# Write CLAUDE.md pointers alongside each AGENTS.md so Claude Code auto-loads.
for dir in "$LEAD_DIR" "$IMPL_DIR" "registrar"; do
    printf '@AGENTS.md\n' > "$UNIT_PATH/#ORG/agents/$dir/CLAUDE.md"
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

PARENT_LEAD_ROLE="${PARENT_LEAD_ROLE_ARG:-Lead}"

sed \
    -e "s|§NNNN|§$NEXT_SECTION|g" \
    -e "s|{unit_name}|$un_esc|g" \
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
    -e "s|{mode — directory \| submodule}|$MODE|g" \
    -e "s|{parent_path}|parent|g" \
    -e "s|{authoring_lead_or_user}|Lead or User|g" \
    "$ESTABLISH_TEMPLATE" > "$ADR_FILE"

# Set the status to 'accepted' at the top.
# The template ships with "Status:** accepted" already — no change needed.

# --- Update the ADR index (parent's #ORG/adr/README.md) ----------------------

# Add a row to the Accepted table. We do a simple sed insertion after the last
# existing §-numbered row. This is best-effort; the Registrar's audit will
# repair the index if anything drifts.
#
# For reliability in this script, we simply append a single line to a known
# location. If the table structure has drifted, the Lead can fix it later.

INDEX="$PARENT_PATH/#ORG/adr/README.md"
if [ -f "$INDEX" ]; then
    # Append a note at the end; Registrar can normalize on next audit.
    cat >> "$INDEX" <<INDEX_NOTE

<!-- §$NEXT_SECTION auto-added by :add-unit on $DATE; Registrar: incorporate into Accepted table. -->
INDEX_NOTE
fi

# --- Git commit (§0018 convention) -------------------------------------------

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
