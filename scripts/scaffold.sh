#!/usr/bin/env bash
#
# scaffold.sh — generate a Silcrow agency in the current working directory.
#
# Invoked by the silcrow:silcrow-init skill. Handles file copy, token
# substitution, git initialization, and initial commit. The agency directory
# is always created inside $PWD — the script does not accept a destination
# argument. To scaffold somewhere else, cd there first.
#
# Agency = root unit + nested sub-units, following the @ <Unit Name>/
# convention (§0012). This script scaffolds the agency's root unit. Sub-units
# are added separately via scripts/add-unit.sh, orchestrated by the
# :silcrow-add-unit skill.
#
# Usage:
#   scaffold.sh <agency_name> <agency_description> \
#               <user_role> <lead_role> <implementer_role> \
#               [--skip-git]
#
# Arguments:
#   agency_name         Display name for the agency (e.g. "Pebble"). Used as
#                       both directory name (`@ Pebble/`) and display in prose.
#   agency_description  One-paragraph description of the agency's purpose.
#   user_role           The user's name or role (e.g. "Trevor", "Director").
#                       Used for the user's directory (`Trevor @ Pebble/`)
#                       and prose references.
#   lead_role           Display name for the Lead role (e.g. "Lead", "Director").
#                       Defaults to "Lead" when the user accepts the default.
#   implementer_role    Display name for the Implementer role (e.g. "Implementer",
#                       "Specialist"). Defaults to "Implementer".
#
# Options:
#   --skip-git          Skip git init, .gitignore creation, and initial commit.
#                       Useful for power users invoking the script directly
#                       inside an environment where git is unwanted.
#
# Exit codes:
#   0   Success.
#   1   Scaffold source not found (plugin misconfiguration).
#   2   Argument error.
#   3   $PWD already contains an `@ <Agency Name>/` directory at the slug
#       derived from the agency name.

set -euo pipefail

# --- Argument parsing --------------------------------------------------------

SKIP_GIT=0
POSITIONAL=()

while [ "$#" -gt 0 ]; do
    case "$1" in
        --skip-git)
            SKIP_GIT=1
            shift
            ;;
        --)
            shift
            while [ "$#" -gt 0 ]; do
                POSITIONAL+=("$1")
                shift
            done
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
Usage: scaffold.sh <agency_name> <agency_description> \
                   <user_role> <lead_role> <implementer_role> \
                   [--skip-git]
USAGE
    exit 2
fi

AGENCY_NAME="${POSITIONAL[0]}"
AGENCY_DESC="${POSITIONAL[1]}"
USER_ROLE="${POSITIONAL[2]}"
LEAD_ROLE="${POSITIONAL[3]}"
IMPL_ROLE="${POSITIONAL[4]}"
DATE="$(date -u +%Y-%m-%d)"

if [ -z "$AGENCY_NAME" ]; then
    echo "Error: agency_name must be non-empty." >&2
    exit 2
fi

# AGENCY_PATH is the agency's own directory, always inside $PWD. All
# scaffolding, git operations, and the initial commit happen inside this
# path — never in $PWD itself, which may be a shared directory containing
# unrelated projects.
AGENCY_PATH="$PWD/@ $AGENCY_NAME"

# --- Locate the plugin's scaffold source -------------------------------------

# Prefer CLAUDE_PLUGIN_ROOT (set by Claude Code when the plugin is installed).
# Fall back to inferring from this script's own location (source checkouts).
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
    PLUGIN_ROOT="$CLAUDE_PLUGIN_ROOT"
else
    SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    PLUGIN_ROOT="$( dirname "$SCRIPT_DIR" )"
fi

SRC="$PLUGIN_ROOT/scaffold/unit"

if [ ! -d "$SRC" ]; then
    echo "Error: scaffold source not found at $SRC" >&2
    echo "The plugin may not be installed correctly." >&2
    exit 1
fi

# --- Pre-flight conflict check -----------------------------------------------

# Refuse to overwrite an existing scaffold. The check is narrow on purpose:
# only the SPECIFIC `@ <Agency Name>/` we're about to create matters. Unrelated
# `@ */` siblings in $PWD (other agencies, archives, etc.) are not conflicts.
# A scaffolded unit always has its `1 | Canon/` subdirectory; we use that
# as the marker.
if [ -d "$AGENCY_PATH/1 | Canon" ]; then
    echo "Error: $AGENCY_PATH is already a scaffolded unit." >&2
    echo "Refusing to overwrite. Pick a different agency name." >&2
    exit 3
fi

# --- Create the agency tree --------------------------------------------------
#
# Per §0012's flat layout: agents and governance folders all sit as direct
# children of `@ <Unit Name>/`. Agent dirs are `<Role> @ <Unit Name>/`.
# Governance folders are constants (`1 | Canon`, `2 | Working Files`,
# `3 | Silcrow Agency Reference`) — no per-unit suffix. Subfolders
# (accepted/, foundations/, inbox/, etc.) carry no suffix either.

mkdir -p \
    "$AGENCY_PATH/$USER_ROLE @ $AGENCY_NAME/inbox/archive" \
    "$AGENCY_PATH/$LEAD_ROLE @ $AGENCY_NAME/inbox/archive" \
    "$AGENCY_PATH/$IMPL_ROLE @ $AGENCY_NAME/inbox/archive" \
    "$AGENCY_PATH/Registrar @ $AGENCY_NAME/inbox/archive" \
    "$AGENCY_PATH/1 | Canon/_templates" \
    "$AGENCY_PATH/1 | Canon/accepted" \
    "$AGENCY_PATH/1 | Canon/proposed" \
    "$AGENCY_PATH/1 | Canon/superseded" \
    "$AGENCY_PATH/1 | Canon/rejected" \
    "$AGENCY_PATH/2 | Working Files" \
    "$AGENCY_PATH/3 | Silcrow Agency Reference/foundations"

# --- Substitution helper -----------------------------------------------------
#
# Writes a copy of src to dst with placeholders replaced. Uses | as the sed
# delimiter so values containing / don't break it. Escapes any | characters
# in values to avoid delimiter confusion.
#
# At the agency's root unit, {unit_name} = AGENCY_NAME (the root unit shares
# the agency's name). add-unit.sh overrides {unit_name} for sub-units.
subst() {
    local src="$1"
    local dst="$2"
    # Escape | for sed safety (rare but possible in user-supplied descriptions).
    local an_esc="${AGENCY_NAME//|/\\|}"
    local ad_esc="${AGENCY_DESC//|/\\|}"
    sed \
        -e "s|{agency_name}|$an_esc|g" \
        -e "s|{agency_description}|$ad_esc|g" \
        -e "s|{unit_name}|$an_esc|g" \
        -e "s|{user_role}|$USER_ROLE|g" \
        -e "s|{lead_role}|$LEAD_ROLE|g" \
        -e "s|{implementer_role}|$IMPL_ROLE|g" \
        -e "s|{date}|$DATE|g" \
        "$src" > "$dst"
}

# --- Empty placeholder files (.gitkeep) --------------------------------------

touch \
    "$AGENCY_PATH/$USER_ROLE @ $AGENCY_NAME/inbox/archive/.gitkeep" \
    "$AGENCY_PATH/$LEAD_ROLE @ $AGENCY_NAME/inbox/archive/.gitkeep" \
    "$AGENCY_PATH/$IMPL_ROLE @ $AGENCY_NAME/inbox/archive/.gitkeep" \
    "$AGENCY_PATH/Registrar @ $AGENCY_NAME/inbox/archive/.gitkeep" \
    "$AGENCY_PATH/1 | Canon/proposed/.gitkeep" \
    "$AGENCY_PATH/1 | Canon/superseded/.gitkeep" \
    "$AGENCY_PATH/1 | Canon/rejected/.gitkeep"

# --- Copy and substitute files -----------------------------------------------

# Top-level unit README
subst "$SRC/README.md" "$AGENCY_PATH/README.md"

# Agent instructions. Each agent directory gets only AGENTS.md — the universal
# cross-tool convention. Claude Code auto-loads it natively; Codex/Cursor/Copilot
# already used it.
subst "$SRC/User/AGENTS.md"         "$AGENCY_PATH/$USER_ROLE @ $AGENCY_NAME/AGENTS.md"
subst "$SRC/Lead/AGENTS.md"         "$AGENCY_PATH/$LEAD_ROLE @ $AGENCY_NAME/AGENTS.md"
subst "$SRC/Implementer/AGENTS.md"  "$AGENCY_PATH/$IMPL_ROLE @ $AGENCY_NAME/AGENTS.md"
subst "$SRC/Registrar/AGENTS.md"    "$AGENCY_PATH/Registrar @ $AGENCY_NAME/AGENTS.md"

# Canon: README, templates, accepted, superseded
subst "$SRC/1 | Canon/README.md" "$AGENCY_PATH/1 | Canon/README.md"

for f in "$SRC/1 | Canon/_templates"/*.md; do
    subst "$f" "$AGENCY_PATH/1 | Canon/_templates/$(basename "$f")"
done

for f in "$SRC/1 | Canon/accepted"/*.md; do
    subst "$f" "$AGENCY_PATH/1 | Canon/accepted/$(basename "$f")"
done

for f in "$SRC/1 | Canon/superseded"/*.md; do
    [ -f "$f" ] && subst "$f" "$AGENCY_PATH/1 | Canon/superseded/$(basename "$f")"
done

# Silcrow Agency Reference (root unit only): top-level docs + foundations
subst "$SRC/3 | Silcrow Agency Reference/README.md" "$AGENCY_PATH/3 | Silcrow Agency Reference/README.md"

for f in "$SRC/3 | Silcrow Agency Reference"/*.md; do
    [ "$(basename "$f")" = "README.md" ] && continue
    subst "$f" "$AGENCY_PATH/3 | Silcrow Agency Reference/$(basename "$f")"
done

for f in "$SRC/3 | Silcrow Agency Reference/foundations"/*.md; do
    subst "$f" "$AGENCY_PATH/3 | Silcrow Agency Reference/foundations/$(basename "$f")"
done

# Working Files — open container for operational artifacts. Ships only a
# README explaining its purpose; the unit fills it in over time.
subst "$SRC/2 | Working Files/README.md" "$AGENCY_PATH/2 | Working Files/README.md"

# --- Git initialization (§0013, §0014, §0015) --------------------------------
#
# The agency is always its own self-contained git repo. All git operations
# target AGENCY_PATH only — $PWD is never touched. We do not inspect $PWD's
# git state; whatever exists above the agency is outside the scaffold's concern.

if [ "$SKIP_GIT" -eq 0 ]; then
    # Initialize the agency as its own git repo. `git init` is idempotent
    # in an already-initialized directory; if a .git/ already exists inside
    # AGENCY_PATH (extremely unlikely on a fresh scaffold), it's a no-op.
    (cd "$AGENCY_PATH" && git init --quiet)

    # Write the default .gitignore per §0014. Only write if not already
    # present (the user might have authored their own).
    if [ ! -f "$AGENCY_PATH/.gitignore" ]; then
        cat > "$AGENCY_PATH/.gitignore" <<'GITIGNORE'
# OS
.DS_Store
Thumbs.db
.Spotlight-V100
.Trashes

# Editors
.vscode/
.idea/
*.swp
*.swo
*~

# Secrets (common patterns)
.env
.env.*
*.pem
*.key
credentials.json
GITIGNORE
    fi

    # Initial commit (§0015 — governance commits cite §NNNN). Only commit
    # if the agency repo doesn't have a HEAD yet (i.e., we just initialized
    # it). Idempotent on re-runs.
    if ! (cd "$AGENCY_PATH" && git rev-parse --verify HEAD >/dev/null 2>&1); then
        (cd "$AGENCY_PATH" && \
            git add . && \
            git commit --quiet -m "Initialize agency @ $AGENCY_NAME (§0001)")
    fi
fi

# --- Success output ----------------------------------------------------------

echo "✓ Scaffolded $AGENCY_NAME at $AGENCY_PATH"
