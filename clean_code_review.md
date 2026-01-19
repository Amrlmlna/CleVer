# Flutter Clean Code Review

## Overview
I have reviewed the codebase in the following directories:
*   `lib/presentation/ads`
*   `lib/presentation/ai`
*   `lib/presentation/common`
*   `lib/presentation/cv`
*   `lib/presentation/dashboard`
*   `lib/presentation/home`
*   `lib/presentation/onboarding`
*   `lib/presentation/profile`
*   `lib/presentation/templates`

## ✅ Actions Taken (Refactoring)
### 1. Unified Carousel Logic (DRY)
**Problem:** `AIBannerCarousel` and `DraftsBannerCarousel` duplicated 90% of their logic.
**Solution:** Created `AutoSlideBanner` in `common/widgets`. Refactored both carousels to use this shared component.

### 2. Extracted Experience Dialog (SRP)
**Problem:** `ExperienceListForm` (`lib/presentation/profile/widgets/experience_list_form.dart`) contained a private class `_ExperienceDialog`. This violates the Single Responsibility Principle, as the ListForm was responsible for both *displaying* the list and *defining* the edit UI.
**Solution:** Extracted logic into `lib/presentation/profile/widgets/experience_dialog.dart`.
**Benefit:** improved readability of `ExperienceListForm` and makes the dialog testable/reusable.

## 🔍 Detailed Review Findings

### 1. `lib/presentation/onboarding` & `lib/presentation/profile`
*   **Status:** ✅ Good Reuse.
*   **Observations:** The onboarding flow correctly reuses the forms from the profile feature (e.g., `OnboardingPersonalStep` uses `PersonalInfoForm`). This is excellent adherence to DRY.
*   **Minor Issue:** `PersonalInfoForm` contains repetitive `TextFormField` definitions with almost identical decoration code.
*   **Recommendation:** Create a `CustomTextField` widget to standardize the input style (border, fill color, prefix icon structure) across the app.

### 2. `lib/presentation/home`
*   **`HeroSection.dart`**: Contains hardcoded black/white colors. Recommended to use `Theme.of(context).primaryColor` or `colorScheme.onSurface` for better long-term maintainability.
*   **`RecentDraftsList.dart`**: Clean implementation using Riverpod. Logic is well-separated.

### 3. `lib/presentation/templates`
*   **`TemplateGalleryCard.dart`**: Hardcoded gradient colors. While acceptable for specific UI designs, it's better to store these in a `AppColors` constant file if they are part of the brand identity.

## 🚀 General Clean Code Recommendations

1.  **Strict Theming:**
    *   I see `Colors.grey[900]` and `Color(0xFF...)` scattered in widgets. Moving these to `ThemeData` extensions or a central palette will make your app much easier to redesign or add Dark Mode to later.
2.  **Input Standardization:**
    *   Extract a `AppTextFormField` wrapper. This usually reduces form code size by 30-40% and ensures every input behaves consistently.
3.  **State Management:**
    *   Riverpod usage in `home` seems correct. `setState` in `profile` forms is also correct for ephemeral UI state.

## Next Steps
*   [ ] Create `AppTextFormField` to clean up `PersonalInfoForm` and `ExperienceDialog`.
*   [ ] Move hardcoded strings to `l10n`.
