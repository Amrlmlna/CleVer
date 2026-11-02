# Onboarding Redesign — Analytics Cutover Memo

**Cutover release:** the first production build containing the Clever
onboarding redesign (branch `feat/onboarding-redesign`). PostHog Android
event delivery only starts working from this release too (see below).

## Event-semantics changes (do NOT silently compare across the cutover)

| Event | Before | After |
|---|---|---|
| `onboarding_welcome_step_viewed` | phase `welcome`, steps 0–5 (legacy 6-step questionnaire) | phase `welcome`, steps 1–8 (new combined journey: questionnaire 1–7 + career-bank intro 8/8) |
| `onboarding_data_input_step_viewed` | phase `data_input`, steps 0–6 (7-page panel) | phase `data_input`, steps 0–6 (same panel steps, new UI; step 0 now fires on panel-sheet open instead of route mount) |
| `onboarding_completed` | fired at panel submit | unchanged, same trigger |
| `auth_guard_viewed` / `auth_guard_interaction` (feature `momentum_forced_auth`) | fired post-onboarding for unauthenticated users | **retired** — post-panel users are always authenticated; the forced wall branch was removed |
| `identify` timing | end of onboarding (panel submit → sign-in) | top of the funnel (GetStarted auth step); historical anonymous→identified stitching changes shape |
| `onboarding_discovery_selected` | defined, never fired | **removed** with the redesign (no discovery-source question exists in the approved design) |

## Android delivery fix

posthog_flutter was lockfile-pinned at 5.11.1 whose Android dependency
range resolved to native SDKs incompatible with the plugin's
`PostHogAndroidConfig` calls (`NoSuchMethodError` at init) — **no events
were ever delivered from Android**. Upgraded to 5.58.4 (native min
3.75.0). All historical Android funnel numbers are silently zero; treat
this release as the first verifiable Android data.

## Dashboards

- Split onboarding funnels at the cutover release; don't blend.
- Funnel order is now: `$screen_view /onboarding` → auth → `data_input`
  0–6 → `onboarding_completed`.
