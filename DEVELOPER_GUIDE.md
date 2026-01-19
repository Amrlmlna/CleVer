# 📘 Developer Guide

## 🏗 Project Architecture
This project follows a **Feature-First** directory structure. Code is organized by domain feature rather than by layer.

### Directory Structure
*   `lib/presentation/`
    *   `common/`: Shared widgets and utilities used across multiple features.
    *   `<feature_name>/`: (e.g., `ads`, `cv`, `profile`)
        *   `pages/`: Full screen widgets.
        *   `widgets/`: Components specific to this feature.
        *   `providers/`: State management (Riverpod) for this feature.
*   `lib/domain/`: Entities and business logic.
*   `lib/data/`: Repositories and data sources.

---

## 🛠 Shared Components & Best Practices

### 1. Carousel & Banners
**Widget:** `AutoSlideBanner`
**Location:** `lib/presentation/common/widgets/auto_slide_banner.dart`
**Usage:** Use this widget for *any* auto-sliding banner or carousel.
*   ✅ **Do:** Use `AutoSlideBanner(items: [...], itemBuilder: ...)`
*   ❌ **Don't:** Manually implement `Timer` or `PageController` in your widget.

### 2. Dialogs & Modals
**Principle:** Single Responsibility.
*   If a complex form is shown in a dialog, create a separate widget file for it (e.g., `ExperienceDialog`).
*   Do not define private dialog classes (`_MyDialog`) inside a parent list widget.

### 3. Theming & Styling
*   **Colors:** Access colors via `Theme.of(context).colorScheme` or `context.theme`. Avoid hardcoded `Color(0xFF...)`.
*   **Text:** Use `Theme.of(context).textTheme`.

---

## 🎨 How-To: Adding New CV Templates

The system is designed to be dynamic. PDF generation requires precise layout logic.

### Step 1: Add Template Metadata
**File:** `lib/data/repositories/template_repository.dart`
Add a new `CVTemplate` object to the `_allTemplates` list:

```dart
const CVTemplate(
  id: 'MyNewDesign',          // Unique ID
  name: 'Minimalist Pro',     // Display Name
  description: 'Clean whitespace with a focus on typography.',
  thumbnailPath: 'assets/templates/minimalist_preview.png', 
  isPremium: true,
  tags: ['Minimal', 'Clean'],
),
```

### Step 2: Add Assets
1.  Design a preview image.
2.  Save it to `assets/templates/`.

### Step 3: Implement PDF Rendering Logic
**File:** `lib/core/utils/pdf_generator.dart`
Update the switch case in `generateAndPrint`:

```dart
switch (cvData.styleId) {
  case 'MyNewDesign':
    return _buildMinimalistLayout(cvData);
  // ...
}
```

**Pro Tip:** Create a private method `_buildMinimalistLayout(CVData data)` that returns a `pw.Widget`.

---

## 🚀 Deployment & Testing
*   **Hot Restart:** Required after adding new assets or templates.
