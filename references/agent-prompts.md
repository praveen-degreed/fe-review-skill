# Agent Prompts

Common context to prepend to ALL agent prompts:

```
Working directory: <WORKTREE_PATH>
You have local codebase access. Use Glob, Grep, and Read tools to explore callers, callees,
and surrounding context of changed functions — not just the diff.

PR diff:
<DIFF>

Review history context:
<REVIEW_CONTEXT_SUMMARY>

IMPORTANT: Do NOT re-raise issues marked FIXED unless the fix is incomplete.
Focus on: still-open prior issues, new code in fix commits, and net-new findings.
```

---

## Agent 1: fe-code-reviewer

```
Review this Angular/TypeScript PR for implementation quality and security:

ANGULAR PATTERNS (CRITICAL - Angular 20+):
1. Are input()/output() functions used instead of @Input/@Output decorators?
2. Is computed() used for derived state instead of getters?
3. Is ChangeDetectionStrategy.OnPush set on all components?
4. Is inject() used instead of constructor injection?
5. Is native control flow used (@if, @for, @switch) instead of *ngIf, *ngFor?
6. Do NOT use `standalone: true` — it's default in Angular 20+
7. Do NOT use @HostBinding/@HostListener — use `host` object instead
8. Is NgOptimizedImage used for static images?
9. Are feature routes lazy loaded?
10. Are Reactive forms used?

TEMPLATE ANTI-PATTERNS (CRITICAL):
11. No globals in templates (new Date(), Math.*, JSON.*)
12. No arrow functions in templates
13. No RegExp in templates
14. No ngClass — use [class.name]="condition"
15. No ngStyle — use [style.property]="value"

TYPESCRIPT QUALITY:
16. Types properly defined? No unjustified `any`?
17. Interfaces instead of inline types?
18. Strict null checking respected?
19. Generics used appropriately?
20. Use `unknown` instead of `any` when uncertain

CODE QUALITY:
21. Clean, readable, well-structured?
22. Follows existing codebase patterns?
23. Incomplete implementations or TODOs?
24. Over-engineering?
25. Code smells (long methods, deep nesting, magic numbers)?

SECURITY:
26. XSS — user input sanitized? [innerHTML] safe?
27. Sensitive data not exposed in templates/console?
28. bypassSecurityTrust*() used with validation?

I18N (CRITICAL):
29. NO inline user-facing strings without translation
    - Use DgxTranslatePipe from @libs/shared/core/pipes/src/translate/translate.pipe.ts
    - Or TranslateService with translateWithDefaults()
30. Translation keys follow naming conventions
31. Error messages/notifications translatable

Be specific with file:line references.
```

---

## Agent 2: fe-logic-reviewer

```
Analyze this Angular/TypeScript PR for logic issues and edge cases:

LOGIC & EDGE CASES:
1. Logical errors or bugs?
2. Unhandled edge cases (empty arrays, null, loading/error states)?
3. Appropriate error handling?
4. Race conditions in async operations?
5. Null/undefined checks in place?

OBSERVABLE & ASYNC:
6. Subscriptions cleaned up? (takeUntilDestroyed, async pipe)
7. switchMap/exhaustMap/concatMap used correctly?
8. Loading and error states handled?
9. Async pipe used in templates?

MEMORY LEAKS (CRITICAL):
10. Subscription leaks - missing takeUntilDestroyed/unsubscribe
11. Event listeners - addEventListener without removeEventListener
12. Timers - setInterval/setTimeout without cleanup
13. DOM references - ElementRef held in closures
14. Third-party - Chart.js, D3 not destroyed

SIGNAL PATTERNS:
15. Signals updated correctly (set vs update)?
16. Computed signals for derived values?
17. Effects used appropriately (not for state updates)?
18. Signal equality for objects/arrays?

COMPONENT LIFECYCLE:
19. ngOnInit for initialization, not constructor?
20. Cleanup in ngOnDestroy or DestroyRef?
21. afterNextRender for DOM operations?

REGRESSION RISKS:
22. Could break existing consumers?
    - Grep for ALL usages of changed components/services
    - Check Input/Output backward compatibility
    - Look for removed/renamed exports

Be specific with file:line references.
```

---

## Agent 3: fe-test-analyzer

```
Analyze tests with Angular/TypeScript quality standards:

CRITICAL REQUIREMENTS:
1. Tests for ALL modified code paths?
2. Edge cases and error scenarios covered?
3. HIGH VALUE (behavior) or LOW VALUE (implementation details)?

ANGULAR TESTING:
4. Spectator used? (preferred in this codebase)
5. Shallow rendering where appropriate?
6. Async handled? (fakeAsync/tick, waitForAsync, done)
7. Change detection triggers correct?

MOCK GUIDELINES:
Appropriate: HTTP calls, external services, complex dependencies
Problematic: Mocking the thing being tested, "toHaveBeenCalled" as only assertion

REJECT tests that:
- Only test "should create" without behavior
- Only verify mock invocations
- Skip error/edge cases

PREFER tests that:
- Assert rendered output
- Verify user interactions
- Test error handling
- Use meaningful assertions

ACCESSIBILITY TESTING (REQUIRED for UI):
- axe-core checks for critical screens?
- Keyboard interactions tested?
- Focus management tested?

For each test file, rate:
- Coverage: Does it cover modified code?
- Value: HIGH / MEDIUM / LOW
- A11y: Has tests? YES / NO / N/A
- Recommendation: KEEP / IMPROVE / ADD MISSING
```

---

## Agent 4: fe-simplifier

```
Analyze changed files for simplification opportunities:

TEMPLATE:
1. Complex expressions → computed() signals?
2. Deeply nested ternaries → @switch or computed?
3. Repeated blocks → ng-templates or child components?

TYPESCRIPT:
4. Simplify with early returns/guard clauses?
5. Use optional chaining, nullish coalescing?
6. Consolidate repeated code into helpers?
7. Remove unnecessary intermediate variables?

RXJS:
8. Simplify complex pipe chains?
9. Nested subscribes → higher-order operators?
10. Combine observables more elegantly?

Focus ONLY on the diff. Be specific with file:line references.
Only suggest changes that genuinely reduce complexity.
Do NOT suggest trivial formatting or style preferences.
```

---

## Agent 5: fe-architecture-reviewer

```
Analyze for architecture, accessibility, and design system compliance.

REFERENCE: .agent-instructions/ folder for standards.

SOLID & CODE ORGANIZATION:
1. Single Responsibility - one purpose per component/service?
   - Components >300 lines need splitting
   - Services mixing HTTP + state + UI should separate
2. File naming: feature-name.component.ts, .service.ts, .model.ts
3. Folder structure: components/, services/, model/

SERVICE LAYER:
4. Services accept UI callbacks? (anti-pattern)
5. Business logic separated from presentation?
6. Circular dependencies?

NX MONOREPO (CRITICAL):
7. Use @degreed/* prefix for library imports
8. No relative imports (../) across library boundaries
9. New libraries have barrel exports (index.ts)

DUPLICATE WORK - SEARCH BEFORE CREATING:
10. Grep for similar existing implementations
11. Check @degreed/apollo, libs/shared/ for reusable components
12. Reuse: translateWithDefaults(), modal-helpers, existing pipes

COMPONENT SELECTION PRIORITY:
13. Angular Material → Angular CDK → Apollo → Custom

APOLLO DESIGN SYSTEM:
14. DialogService, DrawerService, ToastService, IconComponent
15. Buttons: tw-btn-primary, tw-btn-secondary-outline, etc.
16. Icons: da-icon with ariaLabel

STYLING:
17. Tailwind with tw- prefix only
18. Design tokens (neutral, primary, accent, success, warning, error)
19. No hardcoded hex/RGB colors

ACCESSIBILITY (WCAG 2.2 AA):
20. Zero a11y linter errors - NO eslint-disable for a11y
21. Semantic HTML: <button> not <div (click)>, <a> not <span (click)>
22. Focus: trapping in modals, restoration on close, visible indicators
23. Keyboard: Enter/Space/Escape/Arrow handling
24. Screen reader: da-icon ariaLabel, aria-live outside @if
25. Forms: label for every input, autocomplete, focus on error
26. Disabled: aria-disabled="true" not native disabled
27. Contrast: 4.5:1 text, 3:1 UI components

Be specific with file:line references.
```
