#!/usr/bin/env bash
#
# scaffold.sh — generate a Silcrow agency at a destination path.
#
# Invoked by the silcrow:silcrow-init skill. Handles file copy, token
# substitution, git initialization, and initial commit.
#
# Agency = root unit + nested sub-units, following the flat @<unit-name>/
# convention (§0014). This script scaffolds the agency's root unit. Sub-units
# are added separately via scripts/add-unit.sh, orchestrated by the
# :silcrow-add-unit skill.
#
# Usage:
#   scaffold.sh <destination> <agency_name> <agency_description> \
#               <user_dir> <user_role> <lead_dir> <lead_role> \
#               <implementer_dir> <implementer_role> \
#               [--skip-git]
#
# Arguments:
#   destination         Absolute path to the agency's root directory.
#                       The script creates/expects this directory and places
#                       @<agency-name>/ inside it.
#   agency_name         Display name for the agency (e.g. "Acme Co").
#   agency_description  One-paragraph description of the agency's purpose.
#   user_dir            Directory name for the User (e.g. "trevor").
#   user_role           Display name for the User role (e.g. "Trevor").
#   lead_dir            Directory name for the Lead (e.g. "lead").
#   lead_role           Display name for the Lead role (e.g. "Lead").
#   implementer_dir     Directory name for the Implementer (e.g. "implementer").
#   implementer_role    Display name for the Implementer role (e.g. "Implementer").
#
# Options:
#   --skip-git          Skip git init, .gitignore creation, and initial commit.
#                       Use when the user declined git or when the destination
#                       is already inside a git repo.
#
# Exit codes:
#   0   Success.
#   1   Scaffold source not found (plugin misconfiguration).
#   2   Argument error.
#   3   Destination already contains an @*/ unit directory.

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

if [ "${#POSITIONAL[@]}" -ne 9 ]; then
    cat >&2 <<'USAGE'
Usage: scaffold.sh <destination> <agency_name> <agency_description> \
                   <user_dir> <user_role> <lead_dir> <lead_role> \
                   <implementer_dir> <implementer_role> \
                   [--skip-git]
USAGE
    exit 2
fi

DST="${POSITIONAL[0]}"
AGENCY_NAME="${POSITIONAL[1]}"
AGENCY_DESC="${POSITIONAL[2]}"
USER_DIR="${POSITIONAL[3]}"
USER_ROLE="${POSITIONAL[4]}"
LEAD_DIR="${POSITIONAL[5]}"
LEAD_ROLE="${POSITIONAL[6]}"
IMPL_DIR="${POSITIONAL[7]}"
IMPL_ROLE="${POSITIONAL[8]}"
DATE="$(date -u +%Y-%m-%d)"

# The agency is the root unit. Compute its slug from the destination basename
# (stripping any leading @). At the agency level, {unit_name} = AGENCY_DIR
# and {unit_display} = AGENCY_NAME, since the root unit shares the agency's name.
DST_BASENAME="$(basename "$DST")"
AGENCY_DIR="${DST_BASENAME#@}"

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

# Refuse to overwrite an existing scaffold. Per §0014, any @<unit-name>/
# directory marks a unit; if one exists at the destination, this is
# already-scaffolded territory.
EXISTING_UNIT_MARKER="$(find "$DST" -maxdepth 1 -type d -name '@*' 2>/dev/null | head -1 || true)"
if [ -n "$EXISTING_UNIT_MARKER" ]; then
    echo "Error: destination already contains $(basename "$EXISTING_UNIT_MARKER")." >&2
    echo "This directory appears to be a scaffolded unit already." >&2
    echo "Refusing to overwrite. Choose a different destination." >&2
    exit 3
fi

# --- Nested .git detection (informational) -----------------------------------

# If the user is scaffolding inside a directory that already contains nested
# git repos (e.g., an existing codebase with its own .git/), note them so the
# skill can surface the information for the user to decide about later.
NESTED_GITS=()
if [ -d "$DST" ]; then
    # Find .git directories that aren't at the destination root itself.
    while IFS= read -r -d '' nested; do
        # Skip the destination root's own .git (we'll handle that below).
        if [ "$nested" != "$DST/.git" ]; then
            NESTED_GITS+=("$nested")
        fi
    done < <(find "$DST" -name .git -type d -print0 2>/dev/null || true)
fi

# --- Create the destination tree ---------------------------------------------
#
# Per §0014's flat layout: agents, CANON, OPS, REFERENCE all sit as direct
# children of @<unit-name>/, each carrying the @<unit-name> suffix. Subfolders
# (accepted/, foundations/, inbox/, etc.) do not carry the suffix.

mkdir -p \
    "$DST/@$AGENCY_DIR/$USER_DIR@$AGENCY_DIR/inbox/archive" \
    "$DST/@$AGENCY_DIR/$LEAD_DIR@$AGENCY_DIR/inbox/archive" \
    "$DST/@$AGENCY_DIR/$IMPL_DIR@$AGENCY_DIR/inbox/archive" \
    "$DST/@$AGENCY_DIR/registrar@$AGENCY_DIR/inbox/archive" \
    "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/_templates" \
    "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/accepted" \
    "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/proposed" \
    "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/superseded" \
    "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/rejected" \
    "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/anti-patterns" \
    "$DST/@$AGENCY_DIR/OPS@$AGENCY_DIR" \
    "$DST/@$AGENCY_DIR/REFERENCE@$AGENCY_DIR/foundations"

# --- Substitution helper -----------------------------------------------------

# Writes a copy of src to dst with placeholders replaced.
# Uses | as the sed delimiter so values containing / don't break it.
# Escapes any | characters in values to avoid delimiter confusion.
#
# Agent identity follows the role@unit-name convention (§0014). At the agency
# level, {unit_name} = AGENCY_DIR and {unit_display} = AGENCY_NAME because the
# root unit shares the agency's name. add-unit.sh overrides these for sub-units.
subst() {
    local src="$1"
    local dst="$2"
    # Escape | for sed safety (rare but possible in descriptions).
    local an_esc="${AGENCY_NAME//|/\\|}"
    local ad_esc="${AGENCY_DESC//|/\\|}"
    sed \
        -e "s|{agency_name}|$an_esc|g" \
        -e "s|{agency_description}|$ad_esc|g" \
        -e "s|{agency_dir}|$AGENCY_DIR|g" \
        -e "s|{unit_name}|$AGENCY_DIR|g" \
        -e "s|{unit_display}|$an_esc|g" \
        -e "s|{user_dir}|$USER_DIR|g" \
        -e "s|{user_role}|$USER_ROLE|g" \
        -e "s|{lead_dir}|$LEAD_DIR|g" \
        -e "s|{lead_role}|$LEAD_ROLE|g" \
        -e "s|{implementer_dir}|$IMPL_DIR|g" \
        -e "s|{implementer_role}|$IMPL_ROLE|g" \
        -e "s|{date}|$DATE|g" \
        "$src" > "$dst"
}

# --- Empty placeholder files (.gitkeep) --------------------------------------

touch \
    "$DST/@$AGENCY_DIR/$USER_DIR@$AGENCY_DIR/inbox/archive/.gitkeep" \
    "$DST/@$AGENCY_DIR/$LEAD_DIR@$AGENCY_DIR/inbox/archive/.gitkeep" \
    "$DST/@$AGENCY_DIR/$IMPL_DIR@$AGENCY_DIR/inbox/archive/.gitkeep" \
    "$DST/@$AGENCY_DIR/registrar@$AGENCY_DIR/inbox/archive/.gitkeep" \
    "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/proposed/.gitkeep" \
    "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/superseded/.gitkeep" \
    "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/rejected/.gitkeep"

# --- Copy and substitute files -----------------------------------------------

# Top-level unit README
subst "$SRC/README.md" "$DST/@$AGENCY_DIR/README.md"

# Agent instructions. Per §0014's agent-identity convention, every agent's
# directory is named <role-dir>@<unit-name>/. At the agency level the unit-name
# is the agency's slug (AGENCY_DIR), so directories look like trevor@acme/,
# lead@acme/, etc. The Registrar role-dir is fixed as "registrar".
#
# Each agent directory gets two files: AGENTS.md (the canonical instructions,
# auto-loaded by Codex/Cursor/Copilot/etc.) and CLAUDE.md (a one-line pointer,
# `@AGENTS.md`, that Claude Code auto-loads and recursively imports).
subst "$SRC/user/AGENTS.md"         "$DST/@$AGENCY_DIR/$USER_DIR@$AGENCY_DIR/AGENTS.md"
subst "$SRC/lead/AGENTS.md"         "$DST/@$AGENCY_DIR/$LEAD_DIR@$AGENCY_DIR/AGENTS.md"
subst "$SRC/implementer/AGENTS.md"  "$DST/@$AGENCY_DIR/$IMPL_DIR@$AGENCY_DIR/AGENTS.md"
subst "$SRC/registrar/AGENTS.md"    "$DST/@$AGENCY_DIR/registrar@$AGENCY_DIR/AGENTS.md"

for dir in "$USER_DIR@$AGENCY_DIR" "$LEAD_DIR@$AGENCY_DIR" "$IMPL_DIR@$AGENCY_DIR" "registrar@$AGENCY_DIR"; do
    printf '@AGENTS.md\n' > "$DST/@$AGENCY_DIR/$dir/CLAUDE.md"
done

# CANON tree: README, templates, accepted, superseded, anti-patterns
subst "$SRC/CANON/README.md"                     "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/README.md"
subst "$SRC/CANON/anti-patterns/README.md"       "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/anti-patterns/README.md"

for f in "$SRC/CANON/_templates"/*.md; do
    subst "$f" "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/_templates/$(basename "$f")"
done

for f in "$SRC/CANON/accepted"/*.md; do
    subst "$f" "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/accepted/$(basename "$f")"
done

for f in "$SRC/CANON/superseded"/*.md; do
    # Only copy if present (scaffold may ship superseded/§0008 or none).
    [ -f "$f" ] && subst "$f" "$DST/@$AGENCY_DIR/CANON@$AGENCY_DIR/superseded/$(basename "$f")"
done

# REFERENCE tree (root unit only): top-level docs + foundations
subst "$SRC/REFERENCE/README.md" "$DST/@$AGENCY_DIR/REFERENCE@$AGENCY_DIR/README.md"

for f in "$SRC/REFERENCE"/*.md; do
    # Skip the README we already copied to avoid double-substitution.
    [ "$(basename "$f")" = "README.md" ] && continue
    subst "$f" "$DST/@$AGENCY_DIR/REFERENCE@$AGENCY_DIR/$(basename "$f")"
done

for f in "$SRC/REFERENCE/foundations"/*.md; do
    subst "$f" "$DST/@$AGENCY_DIR/REFERENCE@$AGENCY_DIR/foundations/$(basename "$f")"
done

# OPS — open container for operational artifacts. Ships only a README explaining
# its purpose; the unit fills it in over time.
subst "$SRC/OPS/README.md" "$DST/@$AGENCY_DIR/OPS@$AGENCY_DIR/README.md"

# --- Git initialization (§0016, §0017) ---------------------------------------

if [ "$SKIP_GIT" -eq 0 ]; then
    # Only run git init if the destination isn't already inside a repo.
    # `git rev-parse --is-inside-work-tree` exits 0 if inside a repo.
    if ! (cd "$DST" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        (cd "$DST" && git init --quiet)
    fi

    # Write default .gitignore per §0016, only if one doesn't already exist.
    if [ ! -f "$DST/.gitignore" ]; then
        cat > "$DST/.gitignore" <<'GITIGNORE'
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

    # Initial commit (§0017 — governance commits cite §NNNN).
    # Only commit if we're in a repo we just initialized (no existing HEAD) OR
    # if there are staged changes. We avoid committing if the surrounding repo
    # already has history — the user can make their own initial commit then.
    if (cd "$DST" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        # Check if there's no HEAD yet (fresh repo).
        if ! (cd "$DST" && git rev-parse --verify HEAD >/dev/null 2>&1); then
            (cd "$DST" && \
                git add . && \
                git commit --quiet -m "Initialize agency @$AGENCY_NAME (§0001)")
        fi
    fi
fi

# --- Success output ----------------------------------------------------------

echo "✓ Scaffolded $AGENCY_NAME at $DST"

# Report nested git findings for the skill to surface.
if [ "${#NESTED_GITS[@]}" -gt 0 ]; then
    echo "! Detected nested .git/ directories (the Registrar will surface these at first audit):"
    for n in "${NESTED_GITS[@]}"; do
        echo "  - $n"
    done
fi
