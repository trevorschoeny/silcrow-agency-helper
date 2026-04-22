#!/usr/bin/env bash
#
# scaffold.sh — generate an agent-org-scaffold agency at a destination path.
#
# Invoked by the agent-org-scaffold:init skill. Handles file copy, token
# substitution, git initialization, and initial commit.
#
# Agency = top-level unit, following the #ORG/ + @<unit>/ convention (§0015).
# This script scaffolds the agency itself. Sub-units are added separately via
# scripts/add-unit.sh, orchestrated by the :add-unit skill.
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
#                       #ORG/ inside it.
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
#   3   Destination conflict (existing #ORG/ or scaffold residue).

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

# --- Locate the plugin's scaffold source -------------------------------------

# Prefer CLAUDE_PLUGIN_ROOT (set by Claude Code when the plugin is installed).
# Fall back to inferring from this script's own location (source checkouts).
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
    PLUGIN_ROOT="$CLAUDE_PLUGIN_ROOT"
else
    SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    PLUGIN_ROOT="$( dirname "$SCRIPT_DIR" )"
fi

SRC="$PLUGIN_ROOT/scaffold/#ORG"

if [ ! -d "$SRC" ]; then
    echo "Error: scaffold source not found at $SRC" >&2
    echo "The plugin may not be installed correctly." >&2
    exit 1
fi

# --- Pre-flight conflict check -----------------------------------------------

# Refuse to overwrite an existing scaffold. The #ORG/ marker identifies a unit;
# if it already exists at the destination, this is already-scaffolded territory.
if [ -e "$DST/#ORG" ]; then
    echo "Error: destination already contains #ORG/." >&2
    echo "This directory appears to be a scaffolded agency or unit already." >&2
    echo "Refusing to overwrite. Remove #ORG/ first or choose a different destination." >&2
    exit 3
fi

# Also refuse if legacy flat layout is present (pre-#ORG/ scaffolds).
for path in adr agents docs proposed; do
    if [ -d "$DST/$path" ]; then
        echo "Error: destination contains legacy scaffold directory '$path/'." >&2
        echo "This looks like an older-style scaffold that needs migration via :update." >&2
        echo "Refusing to overwrite." >&2
        exit 3
    fi
done

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

mkdir -p \
    "$DST/#ORG/agents/$USER_DIR/inbox/archive" \
    "$DST/#ORG/agents/$LEAD_DIR/inbox/archive" \
    "$DST/#ORG/agents/$IMPL_DIR/inbox/archive" \
    "$DST/#ORG/agents/registrar/inbox/archive" \
    "$DST/#ORG/adr/_templates" \
    "$DST/#ORG/adr/accepted" \
    "$DST/#ORG/adr/proposed" \
    "$DST/#ORG/adr/superseded" \
    "$DST/#ORG/adr/rejected" \
    "$DST/#ORG/adr/anti-patterns" \
    "$DST/#ORG/docs/foundations"

# --- Substitution helper -----------------------------------------------------

# Writes a copy of src to dst with the nine placeholders replaced.
# Uses | as the sed delimiter so values containing / don't break it.
# Escapes any | characters in values to avoid delimiter confusion.
subst() {
    local src="$1"
    local dst="$2"
    # Escape | for sed safety (rare but possible in descriptions).
    local an_esc="${AGENCY_NAME//|/\\|}"
    local ad_esc="${AGENCY_DESC//|/\\|}"
    sed \
        -e "s|{agency_name}|$an_esc|g" \
        -e "s|{agency_description}|$ad_esc|g" \
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
    "$DST/#ORG/agents/$USER_DIR/inbox/archive/.gitkeep" \
    "$DST/#ORG/agents/$LEAD_DIR/inbox/archive/.gitkeep" \
    "$DST/#ORG/agents/$IMPL_DIR/inbox/archive/.gitkeep" \
    "$DST/#ORG/agents/registrar/inbox/archive/.gitkeep" \
    "$DST/#ORG/adr/proposed/.gitkeep" \
    "$DST/#ORG/adr/superseded/.gitkeep" \
    "$DST/#ORG/adr/rejected/.gitkeep"

# --- Copy and substitute files -----------------------------------------------

# Top-level governance README
subst "$SRC/README.md" "$DST/#ORG/README.md"

# Agent instructions (with role-directory remapping for user/lead/impl;
# registrar is always "registrar").
#
# Each agent directory gets two files: AGENTS.md (the canonical instructions,
# auto-loaded by Codex/Cursor/Copilot/etc.) and CLAUDE.md (a one-line pointer,
# `@AGENTS.md`, that Claude Code auto-loads and recursively imports).
subst "$SRC/agents/user/AGENTS.md"         "$DST/#ORG/agents/$USER_DIR/AGENTS.md"
subst "$SRC/agents/lead/AGENTS.md"         "$DST/#ORG/agents/$LEAD_DIR/AGENTS.md"
subst "$SRC/agents/implementer/AGENTS.md"  "$DST/#ORG/agents/$IMPL_DIR/AGENTS.md"
subst "$SRC/agents/registrar/AGENTS.md"    "$DST/#ORG/agents/registrar/AGENTS.md"

for dir in "$USER_DIR" "$LEAD_DIR" "$IMPL_DIR" "registrar"; do
    printf '@AGENTS.md\n' > "$DST/#ORG/agents/$dir/CLAUDE.md"
done

# ADR tree: README, templates, accepted, superseded, anti-patterns
subst "$SRC/adr/README.md"                       "$DST/#ORG/adr/README.md"
subst "$SRC/adr/anti-patterns/README.md"         "$DST/#ORG/adr/anti-patterns/README.md"

for f in "$SRC/adr/_templates"/*.md; do
    subst "$f" "$DST/#ORG/adr/_templates/$(basename "$f")"
done

for f in "$SRC/adr/accepted"/*.md; do
    subst "$f" "$DST/#ORG/adr/accepted/$(basename "$f")"
done

for f in "$SRC/adr/superseded"/*.md; do
    # Only copy if present (scaffold may ship superseded/§0008 or none).
    [ -f "$f" ] && subst "$f" "$DST/#ORG/adr/superseded/$(basename "$f")"
done

# Docs
for f in "$SRC/docs"/*.md; do
    subst "$f" "$DST/#ORG/docs/$(basename "$f")"
done

for f in "$SRC/docs/foundations"/*.md; do
    subst "$f" "$DST/#ORG/docs/foundations/$(basename "$f")"
done

# --- Git initialization (§0017, §0018) ---------------------------------------

if [ "$SKIP_GIT" -eq 0 ]; then
    # Only run git init if the destination isn't already inside a repo.
    # `git rev-parse --is-inside-work-tree` exits 0 if inside a repo.
    if ! (cd "$DST" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        (cd "$DST" && git init --quiet)
    fi

    # Write default .gitignore per §0017, only if one doesn't already exist.
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

    # Initial commit (§0018 — governance commits cite §NNNN).
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
