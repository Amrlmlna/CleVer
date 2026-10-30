# Design System Migration & Deferred Removals

The Clever design system (`lib/core/theme/clever/`) is the new foundation built
from the onboarding redesign (Figma "Clever CV UI" › Staging - Final Page). The
legacy design system is **frozen**: it stays functional for everything outside
onboarding until the app-wide reface, then gets removed entirely.

## Rules

1. No new usages of legacy tokens/styles in redesign work.
2. No new tokens added to legacy files.
3. No early deletion — every item below is removed only when its last consumer
   is migrated (or at the app-wide reface).

## Legacy surfaces (frozen, header-flagged)

| Surface | File | Removal condition |
|---|---|---|
| `AppColors` | `lib/core/theme/app_colors.dart` | Last non-onboarding consumer migrated to `CleverColors` |
| `AppTextStyles` | `lib/core/theme/app_text_styles.dart` | Last non-onboarding consumer migrated to `CleverTypography` |
| `AppTheme` | `lib/core/theme/app_theme.dart` | `lightTheme`/`sheetTheme` consumers migrated; `darkTheme` is already unused (ThemeMode forced light in `main.dart`) |

## Deferred removal checklist (Flutter)

- [ ] `AppTheme.darkTheme` + its wiring in `main.dart` (unused today; safe batch with reface cleanup)
- [ ] Old welcome questionnaire widgets (`onboarding_welcome_page.dart` steps: wall-of-pain, selection list, time scroll, comparison, final reveal, carousel screen, tweet cards, `OnboardingSelectionCard`, `onboarding_morph_painter.dart`) — after the new 7-step flow fully replaces them and the transition window closes
- [ ] `/onboarding/form` standalone route (folded into the new flow)
- [ ] `onboardingAuthCaptureProvider` + `DashboardNavigationHandler.handleOnboardingSuccess` forced auth-wall path (dead once auth happens at Welcome)
- [ ] `onboarding_discovery_selected` analytics event (defined, never fired — wire it or remove it during Phase E)
- [ ] `AppColors`, `AppTextStyles`, `AppTheme` — final deletion after app-wide reface

## Deferred removal checklist (backend, `backend-express`)

- [ ] `aiLimiterAnonymous` + fail-open `optionalAuthMiddleware` on the five public AI routes (`/cv/rewrite`, `/cv/parse`, `/cv/parse-entity`, `/education/parse-study-card`, `/job/extract`) — flip to required auth after the auth-first app release reaches sufficient adoption (anonymous request volume ≈ 0; criterion to be proposed in Phase F)
- [ ] Identity-free AI cache binding (cross-user read + plaintext PII) — bind cache keys to uid or disable sharing
- [ ] `templateId` path-traversal allowlist on `/cv/generate`
- [ ] `maxOutputTokens` cap on the JSON generation path

## Migration status

| Phase | Scope | Status |
|---|---|---|
| A1 | Token layer (`CleverPalette`, `CleverColors`, `CleverTypography`, `CleverDimensions`, `CleverMotion`) | Done |
| A2 | Shared Clever components (buttons, fields, option pills, sheet shell, nav bars, loader) | Pending |
| B | GetStarted / SignUp / SignIn / Welcome steps 1–7 / legal scaffold | Pending |
| C | Input panel restyle (header, method choice, lists, forms, dictate, skills, complete) | Pending |
| D | Loading screens + mascot | Pending |
| E–H | Analytics, backend security, guard cleanup, regression | Pending |
| Reface | Migrate all non-onboarding UI off legacy tokens, then delete legacy files | Pending |
