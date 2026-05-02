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
#               [--agency-dir <slug>] [--skip-git]
#
# Arguments:
#   destination         Absolute path to the directory the agency will live
#                       inside. The script creates @<agency-dir>/ inside this
#                       path; the destination's own basename is irrelevant.
#   agency_name         Display name for the agency (e.g. "Acme Co"). The
#                       agency's directory slug is derived from this by
#                       default (lowercase, spaces → hyphens, slug-safe);
#                       override with --agency-dir.
#   agency_description  One-paragraph description of the agency's purpose.
#   user_dir            Directory name for the User (e.g. "trevor").
#   user_role           Display name for the User role (e.g. "Trevor").
#   lead_dir            Directory name for the Lead (e.g. "lead").
#   lead_role           Display name for the Lead role (e.g. "Lead").
#   implementer_dir     Directory name for the Implementer (e.g. "implementer").
#   implementer_role    Display name for the Implementer role (e.g. "Implementer").
#
# Options:
#   --agency-dir <slug> Override the auto-derived agency directory slug. Use
#                       when the user wants a different slug than slugifying
#                       the agency name produces (e.g. display "Acme Corp"
#                       with dir @acme/).
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
AGENCY_DIR_OVERRIDE=""
POSITIONAL=()

while [ "$#" -gt 0 ]; do
    case "$1" in
        --skip-git)
            SKIP_GIT=1
            shift
            ;;
        --agency-dir)
            AGENCY_DIR_OVERRIDE="$2"
            shift 2
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
                   [--agency-dir <slug>] [--skip-git]
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

# Compute the agency directory slug. By default, derive it from the agency
# display name: lowercase, whitespace → hyphens, strip everything outside
# §0014's unit-name slug constraints (alphanumeric, hyphens, underscores, dots).
# The skill can override via --agency-dir if the user wants a different slug
# than the auto-derivation produces.
if [ -n "$AGENCY_DIR_OVERRIDE" ]; then
    AGENCY_DIR="$AGENCY_DIR_OVERRIDE"
else
    AGENCY_DIR="$(echo "$AGENCY_NAME" \
        | tr '[:upper:]' '[:lower:]' \
        | tr -s ' \t' '-' \
        | sed -E 's/[^a-z0-9._-]//g' \
        | sed -E 's/-+/-/g' \
        | sed -E 's/^-+|-+$//g')"
fi

if [ -z "$AGENCY_DIR" ]; then
    echo "Error: agency name '$AGENCY_NAME' produced an empty slug." >&2
    echo "Pass --agency-dir <slug> with an explicit slug, or pick a different agency name." >&2
    exit 2
fi

# AGENCY_PATH is the agency's own directory. All scaffolding, git operations,
# and the initial commit happen inside this path — never in $DST itself,
# which may be a shared parent directory containing unrelated projects.
AGENCY_PATH="$DST/@$AGENCY_DIR"

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
# only the SPECIFIC @<agency-dir>/ we're about to create matters. Unrelated
# @*/ siblings in $DST (other agencies, archives, etc.) are not conflicts.
# A scaffolded unit always has its CANON@<unit>/ subdirectory; we use that
# as the marker.
if [ -d "$AGENCY_PATH/CANON@$AGENCY_DIR" ]; then
    echo "Error: $AGENCY_PATH is already a scaffolded unit." >&2
    echo "Refusing to overwrite. Choose a different agency name or destination." >&2
    exit 3
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
#
# All git operations target the AGENCY_PATH (the agency's own directory).
# Never touch $DST: it's a parent directory that may contain other unrelated
# projects. The agency is its own self-contained git repo.

if [ "$SKIP_GIT" -eq 0 ]; then
    # Only run git init if the agency isn't already inside an existing repo
    # (e.g., the user is scaffolding the agency inside a project they already
    # have under version control — let that outer repo track the agency).
    if ! (cd "$AGENCY_PATH" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        (cd "$AGENCY_PATH" && git init --quiet)
    fi

    # Write default .gitignore per §0016, only if the agency doesn't already
    # have one (a parent repo's .gitignore is left alone).
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

    # Initial commit (§0017 — governance commits cite §NNNN).
    # Only commit if the agency is in a fresh repo (no HEAD yet). If it's
    # already inside a parent repo with history, the user can stage and
    # commit themselves; we don't commit the parent's content.
    if (cd "$AGENCY_PATH" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        if ! (cd "$AGENCY_PATH" && git rev-parse --verify HEAD >/dev/null 2>&1); then
            (cd "$AGENCY_PATH" && \
                git add . && \
                git commit --quiet -m "Initialize agency @$AGENCY_NAME (§0001)")
        fi
    fi
fi

# --- Success output ----------------------------------------------------------

echo "✓ Scaffolded $AGENCY_NAME at $AGENCY_PATH"
