#!/usr/bin/env bash
#
# add-agent.sh — add a new agent to an existing unit.
#
# Invoked by the silcrow:silcrow-add-agent skill. Creates the agent's
# directory nested inside the unit (with inbox/ and inbox/archive/ per the
# actor-model discipline §0005), renders the establishing ADR per §0008's
# Roster Change Protocol into the unit's `1 | Canon/accepted/`, and exits.
#
# This script is intentionally narrow: mechanics only. The skill handles
# all substantive content — the new agent's AGENTS.md is composed from the
# conversation and written by the skill, edits to existing agents' AGENTS.md
# (work redistribution) are applied by the skill, the unit README's roster
# section is edited by the skill, and the final governance commit per §0015
# is made by the skill once everything is in place.
#
# Usage:
#   add-agent.sh <unit_path> <role_name> <role_purpose> <reports_to> \
#                --agency-name <agency_name> \
#                --user-role <user_role> \
#                --lead-role <lead_role>
#
# Arguments:
#   unit_path        Absolute path to the unit's directory (its basename
#                    must start with `@ `, e.g. /path/to/@ Pebble/). The
#                    new agent will be created as a sibling of the unit's
#                    existing agent dirs and governance folders.
#   role_name        Title-case role name (e.g. "Researcher", "Designer",
#                    "Project Manager"). The agent dir will be named
#                    `<role_name> @ <unit_name>/`.
#   role_purpose     One-sentence description of what this agent owns. Used
#                    in the establishing ADR's Why-statement (placeholder
#                    {one_sentence_purpose}).
#   reports_to       The role name of the existing agent this new agent
#                    reports to (e.g. "Lead", "Director"). Used in the
#                    establishing ADR's "Reports to" section.
#
# Required options:
#   --agency-name    Display name of the agency. Used in the establishing
#                    ADR's prose for references like "the agency's @ <Name>".
#   --user-role      Display name of the agency's user role. Used in the
#                    ADR's prose and the "Authors" line.
#   --lead-role      Display name of the unit's Lead role. Used as the
#                    authoring role in the ADR's "Authors" line.
#
# Exit codes:
#   0   Success.
#   1   Plugin scaffold source not found (Establish Agent template missing).
#   2   Argument error (missing positional or required option).
#   3   Unit path not a unit (basename doesn't start with `@`).
#   4   An agent with this role name already exists in the unit.

set -euo pipefail

# --- Argument parsing --------------------------------------------------------

AGENCY_NAME_ARG=""
USER_ROLE_ARG=""
LEAD_ROLE_ARG=""
POSITIONAL=()

while [ "$#" -gt 0 ]; do
    case "$1" in
        --agency-name)
            AGENCY_NAME_ARG="$2"
            shift 2
            ;;
        --user-role)
            USER_ROLE_ARG="$2"
            shift 2
            ;;
        --lead-role)
            LEAD_ROLE_ARG="$2"
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

if [ "${#POSITIONAL[@]}" -ne 4 ]; then
    cat >&2 <<'USAGE'
Usage: add-agent.sh <unit_path> <role_name> <role_purpose> <reports_to> \
                    --agency-name <agency_name> \
                    --user-role <user_role> \
                    --lead-role <lead_role>
USAGE
    exit 2
fi

UNIT_PATH="${POSITIONAL[0]}"
ROLE_NAME="${POSITIONAL[1]}"
ROLE_PURPOSE="${POSITIONAL[2]}"
REPORTS_TO="${POSITIONAL[3]}"
DATE="$(date -u +%Y-%m-%d)"

# --- Validate required options ------------------------------------------------

if [ -z "$AGENCY_NAME_ARG" ]; then
    echo "Error: --agency-name is required." >&2
    echo "The skill reads it from the unit's silcrow-meta README anchor and passes it explicitly." >&2
    exit 2
fi

if [ -z "$USER_ROLE_ARG" ]; then
    echo "Error: --user-role is required." >&2
    exit 2
fi

if [ -z "$LEAD_ROLE_ARG" ]; then
    echo "Error: --lead-role is required." >&2
    exit 2
fi

AGENCY_NAME="$AGENCY_NAME_ARG"
USER_ROLE="$USER_ROLE_ARG"
LEAD_ROLE="$LEAD_ROLE_ARG"

# --- Validate UNIT_PATH is a unit (basename starts with @) -------------------

UNIT_BASENAME="$(basename "$UNIT_PATH")"
case "$UNIT_BASENAME" in
    @*) ;;
    *)
        echo "Error: unit path '$UNIT_PATH' is not a unit directory (basename must start with @)." >&2
        echo "The skill must be invoked from inside a unit's Lead directory; pass the unit's path (one level up from CWD) as the first argument." >&2
        exit 3
        ;;
esac

# Strip the `@ ` prefix to get the unit's display name.
UNIT_NAME="${UNIT_BASENAME#@ }"

# --- Validate role name doesn't already exist in the unit --------------------

AGENT_PATH="$UNIT_PATH/$ROLE_NAME @ $UNIT_NAME"

if [ -e "$AGENT_PATH" ]; then
    echo "Error: agent '$ROLE_NAME @ $UNIT_NAME' already exists at $AGENT_PATH." >&2
    echo "Pick a different role name, or remove the existing directory first if this is a re-establishment." >&2
    exit 4
fi

# --- Locate plugin scaffold source (for Establish Agent template) ------------

if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
    PLUGIN_ROOT="$CLAUDE_PLUGIN_ROOT"
else
    SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    PLUGIN_ROOT="$( dirname "$SCRIPT_DIR" )"
fi

ESTABLISH_TEMPLATE="$PLUGIN_ROOT/scaffold/unit/1 | Canon/_templates/Establish Agent.md"

if [ ! -f "$ESTABLISH_TEMPLATE" ]; then
    echo "Error: Establish Agent template not found at $ESTABLISH_TEMPLATE" >&2
    exit 1
fi

# --- Determine the next §-number for the establishing ADR --------------------
#
# §-numbers are scoped per-unit (§0003) and never reused — even across the
# accepted/, superseded/, and rejected/ buckets. Scan all three to find the
# highest existing §NNNN and assign the next.

UNIT_CANON="$UNIT_PATH/1 | Canon"
ACCEPTED_DIR="$UNIT_CANON/accepted"

HIGHEST=0
parse_section() {
    # Filenames are `§NNNN | Title.md`. Take everything before the first
    # whitespace, strip the leading §, convert via 10# to avoid octal
    # interpretation of leading zeros.
    local f="$1"
    local name num_part
    name=$(basename "$f")
    num_part="${name%% *}"
    num_part="${num_part#§}"
    echo $((10#$num_part))
}

for dir in "$ACCEPTED_DIR" "$UNIT_CANON/superseded" "$UNIT_CANON/rejected"; do
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

# --- Create the agent directory + inbox/archive ------------------------------
#
# Per §0005, every agent has a private inbox. Per §0011's canon/operational
# split, archived messages live in inbox/archive/. .gitkeep ensures empty
# dirs survive `git add`.

mkdir -p "$AGENT_PATH/inbox/archive"
touch "$AGENT_PATH/inbox/archive/.gitkeep"

# --- Render the establishing ADR ---------------------------------------------
#
# Mechanical placeholders (names, date, §-number, paths) get filled here.
# Substantive placeholders (why-statement specifics, scope details,
# redistribution narrative) remain as `{placeholders}` for the unit's Lead
# to fill in — same pattern as Establish Unit.md.

ADR_FILE="$ACCEPTED_DIR/§$NEXT_SECTION | Establish $ROLE_NAME @ $UNIT_NAME.md"

# Escape | for sed safety (rare, but possible in user-supplied values).
rn_esc="${ROLE_NAME//|/\\|}"
rp_esc="${ROLE_PURPOSE//|/\\|}"
un_esc="${UNIT_NAME//|/\\|}"
an_esc="${AGENCY_NAME//|/\\|}"

sed \
    -e "s|§NNNN|§$NEXT_SECTION|g" \
    -e "s|{role_name}|$rn_esc|g" \
    -e "s|{one_sentence_purpose}|$rp_esc|g" \
    -e "s|{unit_name}|$un_esc|g" \
    -e "s|{agency_name}|$an_esc|g" \
    -e "s|{date}|$DATE|g" \
    -e "s|{user_role}|$USER_ROLE|g" \
    -e "s|{lead_role}|$LEAD_ROLE|g" \
    -e "s|{reports_to}|$REPORTS_TO|g" \
    "$ESTABLISH_TEMPLATE" > "$ADR_FILE"

# --- Update the ADR index (unit's `1 | Canon/README.md`) ---------------------
#
# Append a hint at the end of the index. The Registrar's audit normalizes
# this into the proper Accepted-table row on next run.

INDEX="$UNIT_CANON/README.md"
if [ -f "$INDEX" ]; then
    cat >> "$INDEX" <<INDEX_NOTE

<!-- §$NEXT_SECTION auto-added by :silcrow-add-agent on $DATE; Registrar: incorporate into Accepted table. -->
INDEX_NOTE
fi

# --- Success output ----------------------------------------------------------

cat <<SUMMARY
✓ Created agent directory $AGENT_PATH
  Role:           $ROLE_NAME
  Reports to:     $REPORTS_TO @ $UNIT_NAME
  Establishing ADR: $ADR_FILE
  Section number:   §$NEXT_SECTION

  Next: skill writes the new agent's AGENTS.md, applies redistribution edits
        to existing agents' AGENTS.md, updates the unit README's roster
        section if present, and commits everything together per §0015.
SUMMARY
