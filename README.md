# Frontend PR Review Skill

A Claude Code skill for comprehensive frontend PR reviews. Specialized for Angular 20+, TypeScript, Apollo Design System, and WCAG 2.2 AA accessibility.

## Installation

### One-liner

```bash
curl -sL https://raw.githubusercontent.com/praveen-degreed/fe-review-skill/main/install.sh | bash
```

### Manual

```bash
git clone https://github.com/praveen-degreed/fe-review-skill.git .claude/skills/review-prs
```

## Usage

```bash
# Standard review (5 parallel agents)
/review-prs https://github.com/owner/repo/pull/123

# Deep review (2 independent reviewers x 5 agents)
/review-prs --deep https://github.com/owner/repo/pull/123

# Multiple PRs
/review-prs <PR_URL1> <PR_URL2>
```

## What It Reviews

| Category | Checks |
|----------|--------|
| **Angular Patterns** | input()/output(), computed(), OnPush, inject(), @if/@for, host object |
| **TypeScript** | Types, null safety, generics, no unjustified `any` |
| **Accessibility** | WCAG 2.2 AA, semantic HTML, focus management, keyboard nav, ARIA |
| **Apollo Design** | tw-btn-*, design tokens, da-icon, DialogService |
| **Tests** | Jest/Spectator, meaningful assertions, a11y tests |
| **Memory Leaks** | Subscriptions, event listeners, timers, DOM refs |
| **Architecture** | SOLID, service boundaries, Nx imports, code reuse |
| **i18n** | DgxTranslatePipe, no hardcoded strings |

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated
- Repository access to the PR

## Structure

```
.claude/skills/review-prs/
├── SKILL.md                    # Core workflow (494 words)
└── references/
    ├── agent-prompts.md        # 5 agent prompts
    ├── decision-rules.md       # Approve/reject criteria
    ├── review-template.md      # GitHub comment template
    └── deep-mode.md            # Team consensus logic
```

## Output

Posts directly to GitHub PR with:
- **APPROVE** or **REQUEST CHANGES** verdict
- Categorized findings with file:line references
- Dropped/downgraded findings (transparency)
- PR health assessment

## License

MIT
