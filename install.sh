#!/bin/bash
# Install fe-review-skill for Claude Code

set -e

SKILL_DIR=".claude/skills/review-prs"
REPO_URL="https://raw.githubusercontent.com/praveen-degreed/fe-review-skill/main"

echo "Installing review-prs skill..."

mkdir -p "$SKILL_DIR/references"

curl -sL "$REPO_URL/SKILL.md" -o "$SKILL_DIR/SKILL.md"
curl -sL "$REPO_URL/references/agent-prompts.md" -o "$SKILL_DIR/references/agent-prompts.md"
curl -sL "$REPO_URL/references/decision-rules.md" -o "$SKILL_DIR/references/decision-rules.md"
curl -sL "$REPO_URL/references/review-template.md" -o "$SKILL_DIR/references/review-template.md"
curl -sL "$REPO_URL/references/deep-mode.md" -o "$SKILL_DIR/references/deep-mode.md"

echo ""
echo "Installed to $SKILL_DIR/"
echo ""
echo "Usage: /review-prs <PR_URL>"
echo "       /review-prs --deep <PR_URL>"
