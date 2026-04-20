#!/usr/bin/env bash
#
# scaffold.sh — generate an agent organization scaffold at a destination path.
#
# Invoked by the agent-org-scaffold plugin's init skill. Handles all file copy
# and token substitution. Completes in well under a second.
#
# Usage:
#   scaffold.sh <destination> <project_name> <project_description> \
#               <user_dir> <user_role> <lead_dir> <lead_role> \
#               <implementer_dir> <implementer_role>
#
# Exits non-zero on conflict (destination already contains a scaffold) or any
# other failure. On success prints a brief acknowledgment on stdout.

set -euo pipefail

if [ "$#" -ne 9 ]; then
    cat >&2 <<'USAGE'
Usage: scaffold.sh <destination> <project_name> <project_description> \
                   <user_dir> <user_role> <lead_dir> <lead_role> \
                   <implementer_dir> <implementer_role>
USAGE
    exit 2
fi

DST="$1"
PROJECT_NAME="$2"
PROJECT_DESC="$3"
USER_DIR="$4"
USER_ROLE="$5"
LEAD_DIR="$6"
LEAD_ROLE="$7"
IMPL_DIR="$8"
IMPL_ROLE="$9"
DATE="$(date -u +%Y-%m-%d)"

# Locate the plugin's scaffold directory. Prefer CLAUDE_PLUGIN_ROOT (set by
# Claude Code when the plugin is installed). Fall back to inferring from this
# script's own location, which works when running from a source checkout.
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
    PLUGIN_ROOT="$CLAUDE_PLUGIN_ROOT"
else
    SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    PLUGIN_ROOT="$( dirname "$SCRIPT_DIR" )"
fi

SRC="$PLUGIN_ROOT/scaffold"

if [ ! -d "$SRC" ]; then
    echo "Error: scaffold source not found at $SRC" >&2
    echo "The plugin may not be installed correctly." >&2
    exit 1
fi

# Pre-flight conflict check. Any of these existing at the destination means a
# scaffold (or partial scaffold) is already present; we refuse to overwrite.
for path in agents adr proposed docs/philosophy.md docs/decision-process.md; do
    if [ -e "$DST/$path" ]; then
        echo "Error: destination already contains '$path'." >&2
        echo "Remove existing agents/, adr/, proposed/, and docs files before reinitializing." >&2
        echo "This skill will not merge with or overwrite existing records." >&2
        exit 1
    fi
done

# Check for §*.md files (already-accepted ADRs)
if compgen -G "$DST/§*.md" > /dev/null 2>&1; then
    echo "Error: destination contains §*.md files (existing ADRs)." >&2
    exit 1
fi

# Create the destination tree
mkdir -p \
    "$DST/agents/$USER_DIR/inbox/archive" \
    "$DST/agents/$LEAD_DIR/inbox/archive" \
    "$DST/agents/$IMPL_DIR/inbox/archive" \
    "$DST/agents/registrar/inbox/archive" \
    "$DST/adr/_templates" \
    "$DST/adr/accepted" \
    "$DST/adr/superseded" \
    "$DST/adr/rejected" \
    "$DST/adr/anti-patterns" \
    "$DST/proposed" \
    "$DST/docs/foundations"

# Substitution helper. Writes a copy of src to dst with the nine tokens
# replaced. Uses | as the sed delimiter so values containing / don't break it.
subst() {
    local src="$1"
    local dst="$2"
    sed \
        -e "s|{project_name}|$PROJECT_NAME|g" \
        -e "s|{project_description}|$PROJECT_DESC|g" \
        -e "s|{user_dir}|$USER_DIR|g" \
        -e "s|{user_role}|$USER_ROLE|g" \
        -e "s|{lead_dir}|$LEAD_DIR|g" \
        -e "s|{lead_role}|$LEAD_ROLE|g" \
        -e "s|{implementer_dir}|$IMPL_DIR|g" \
        -e "s|{implementer_role}|$IMPL_ROLE|g" \
        -e "s|{date}|$DATE|g" \
        "$src" > "$dst"
}

# Empty placeholders. .gitkeep files have no content, so touch rather than subst.
touch \
    "$DST/agents/$USER_DIR/inbox/archive/.gitkeep" \
    "$DST/agents/$LEAD_DIR/inbox/archive/.gitkeep" \
    "$DST/agents/$IMPL_DIR/inbox/archive/.gitkeep" \
    "$DST/agents/registrar/inbox/archive/.gitkeep" \
    "$DST/adr/superseded/.gitkeep" \
    "$DST/adr/rejected/.gitkeep" \
    "$DST/proposed/.gitkeep"

# Top-level
subst "$SRC/README.md" "$DST/README.md"

# Agents (with role-directory remapping)
subst "$SRC/agents/user/instructions.md"     "$DST/agents/$USER_DIR/instructions.md"
subst "$SRC/agents/lead/instructions.md"     "$DST/agents/$LEAD_DIR/instructions.md"
subst "$SRC/agents/implementer/instructions.md" "$DST/agents/$IMPL_DIR/instructions.md"
subst "$SRC/agents/registrar/instructions.md" "$DST/agents/registrar/instructions.md"

# ADR tree
subst "$SRC/adr/README.md"                     "$DST/adr/README.md"
subst "$SRC/adr/anti-patterns/README.md"       "$DST/adr/anti-patterns/README.md"

for f in "$SRC/adr/_templates"/*.md; do
    subst "$f" "$DST/adr/_templates/$(basename "$f")"
done

for f in "$SRC/adr/accepted"/*.md; do
    subst "$f" "$DST/adr/accepted/$(basename "$f")"
done
# (The above glob picks up §0001–§0011 and any future seeded ADRs automatically.)

# Docs
for f in "$SRC/docs"/*.md; do
    subst "$f" "$DST/docs/$(basename "$f")"
done

for f in "$SRC/docs/foundations"/*.md; do
    subst "$f" "$DST/docs/foundations/$(basename "$f")"
done

echo "✓ Scaffolded $PROJECT_NAME at $DST"
