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
- [x] Old welcome questionnaire widgets (`onboarding_welcome_page.dart` steps: wall-of-pain, selection list, time scroll, comparison, final reveal, carousel screen, tweet cards, `OnboardingSelectionCard`, `onboarding_morph_painter.dart`) — deleted 2026-10-31 (B3); `/onboarding` now serves `CleverGetStartedPage`
- [ ] `/onboarding/form` standalone route (folded into the new flow)
- [ ] `onboardingAuthCaptureProvider` + `DashboardNavigationHandler.handleOnboardingSuccess` forced auth-wall path (dead once auth happens at Welcome)
- [ ] `onboarding_discovery_selected` analytics event (defined, never fired — wire it or remove it during Phase E)
- [ ] `AppColors`, `AppTextStyles`, `AppTheme` — final deletion after app-wide reface

## Deferred removal checklist (backend, `backend-express`)

- [x] The five AI routes (`/cv/rewrite`, `/cv/parse`, `/cv/parse-entity`, `/education/parse-study-card`, `/job/extract`) now REQUIRE auth like every other endpoint — owner decision 2026-11-05 (no env gate, no anonymous tier; `aiLimiterAnonymous` + the dynamic limiter switch deleted). backend-express `staging` commit `34ab6db`/gate-removal follow-up. Deploy note: pre-auth-first app versions still in production lose these endpoints until they update.
- [x] Identity-free AI cache binding — all AI cache keys + the `/cv/generate` PDF cache key are uid-scoped (`scopedKey` helper)
- [x] `templateId` path-traversal allowlist on `/cv/generate` (templateMetadata check + PDFService path-containment guard)
- [x] `maxOutputTokens` cap (2048) on the JSON generation path

## Migration status

| Phase | Scope | Status |
|---|---|---|
| A1 | Token layer (`CleverPalette`, `CleverColors`, `CleverTypography`, `CleverDimensions`, `CleverMotion`) | Done |
| A2 | Shared Clever components (`clever_button`, `clever_google_button`, `clever_text_field`, `clever_nav_action_bar`, `clever_progress_bar`, `clever_option_tile`, `clever_sheet`, `clever_divider` + widget tests) | Done |
| B | GetStarted / SignUp / SignIn / Welcome steps 1–7 / legal scaffold | Done (device-confirmed; commits 9ec810e…ad244b1) |
| C | Input panel restyle (header, method choice, lists, forms, dictate, skills, complete) | Done (device-confirmed; 8fd4bd8 retired all legacy panel files) |
| D | Loading screens + mascot | Mostly done — getStarted/signUp/signIn/authLoading/step7 mascot live; Import/KHS mascot variants + auth face offsets pending (needs Figwright session) |
| E | Analytics (PostHog 5.58.4 fix, cutover memo, guard sheets) | Done (80101c6 + ba56160); welcome-step events still missing — see analytics-cutover.md |
| F | Backend security (AI routes auth-required, uid cache binding, templateId, token cap) | Done on backend `staging` (owner decision 2026-11-05) |
| G | Auth guard cleanup (sign-in skip, dead auth wall removed) | Done (ad244b1) |
| Reface | Migrate all non-onboarding UI off legacy tokens, then delete legacy files | Pending |
