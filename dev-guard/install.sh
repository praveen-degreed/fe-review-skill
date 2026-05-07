#!/bin/bash
# Install dev-guard -- development-time coding standards
# Installs SKILL.md + references to .claude/skills/dev-guard/ (skill format)
# Also installs fe-standards.md to .agent-instructions/ for always-on loading in Claude Code
set -e

REPO="praveen-degreed/fe-claude-skills"
SKILL_DIR=".claude/skills/dev-guard"
AGENT_INSTRUCTIONS_TARGET=".agent-instructions/fe-dev-guard.md"
LOCAL_MD=".claude/CLAUDE.local.md"
GUARD_REF='- **`.agent-instructions/fe-dev-guard.md`** - FE development guard: Angular, TypeScript, RxJS, a11y, security, testing rules enforced during coding. READ THIS before writing any code.'

echo "Installing dev-guard..."

if ! command -v gh &> /dev/null; then
    echo "Error: gh CLI not found. Install with: brew install gh"
    exit 1
fi

# Install as Agent Skill (portable format)
mkdir -p "$SKILL_DIR/references"
gh api "repos/$REPO/contents/dev-guard/SKILL.md" --jq '.content' | base64 -d > "$SKILL_DIR/SKILL.md"
gh api "repos/$REPO/contents/dev-guard/references/fe-standards.md" --jq '.content' | base64 -d > "$SKILL_DIR/references/fe-standards.md"
echo "Installed skill to $SKILL_DIR/"

# Also install to .agent-instructions/ for always-on loading in Claude Code
mkdir -p .agent-instructions
gh api "repos/$REPO/contents/dev-guard/references/fe-standards.md" --jq '.content' | base64 -d > "$AGENT_INSTRUCTIONS_TARGET"

# Add reference to .claude/CLAUDE.local.md (local-only, not committed to repo)
mkdir -p .claude
if [ -f "$LOCAL_MD" ]; then
    if ! grep -q "fe-dev-guard.md" "$LOCAL_MD"; then
        echo "" >> "$LOCAL_MD"
        echo "$GUARD_REF" >> "$LOCAL_MD"
        echo "Added fe-dev-guard.md reference to $LOCAL_MD"
    else
        echo "fe-dev-guard.md already referenced in $LOCAL_MD"
    fi
else
    cat > "$LOCAL_MD" << 'LOCALEOF'
# Local Development Standards

## READ on every session

LOCALEOF
    echo "$GUARD_REF" >> "$LOCAL_MD"
    echo "Created $LOCAL_MD with fe-dev-guard.md reference"
fi

echo ""
echo "Installed to:"
echo "  $SKILL_DIR/ (Agent Skill format - portable)"
echo "  $AGENT_INSTRUCTIONS_TARGET (always-on loading)"
echo "  Registered in $LOCAL_MD (local-only, not committed)"
echo ""
echo "Claude will read these rules at the start of every conversation."
echo "Other agents can discover the skill via $SKILL_DIR/SKILL.md."
