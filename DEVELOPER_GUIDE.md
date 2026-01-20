# 📘 Developer Guide

## 🏗 System Architecture (Clean Architecture + Serverless)

This project uses a hybrid **Flutter (Client)** + **Next.js (Backend)** architecture to deliver AI features securely and cheaply.

```mermaid
sequenceDiagram
    participant User
    participant Flutter as Flutter App (Client)
    participant NextJS as Next.js API (Backend)
    participant Gemini as Gemini AI (LLM)

    User->>Flutter: Enters Master Profile & Job Input
    User->>Flutter: Clicks "Generate CV"
    
    Note over Flutter: RemoteAIService packages data<br/>into JSON (Profile + Job)
    
    Flutter->>NextJS: POST /api/cv/generate
    
    Note over NextJS: "Career Coach" System Prompt<br/>Embeds user data + job description
    
    NextJS->>Gemini: Send Complex Prompt
    Gemini-->>NextJS: Returns Structured JSON
    
    Note right of Gemini: JSON contains:<br/>1. Summary<br/>2. Tailored Skills<br/>3. REWRITTEN Experience
    
    NextJS-->>Flutter: Returns AI JSON
    
    Note over Flutter: RemoteAIService Merges Data:<br/>Replaces User's orig. description<br/>with AI's "Refined Description"
    
    Flutter->>User: Shows Preview Screen
```

## 🛠 Directory Structure
*   `lib/presentation/`: UI & Widgets (Feature-first).
*   `lib/data/`: Data Layer.
    *   `repositories/`: Logic that decides *where* to get data (Mock vs Remote).
    *   `datasources/`: Actual API calls (`RemoteAIService.dart`).
*   `backend/`: Next.js Serverless Project.
    *   `app/api/`: API Routes.
    *   `types/`: Shared TypeScript interfaces.

## 🚀 Key Data Follow
1.  **Input**: User fills `UserDataFormPage`. Data is stored in `CVCreationProvider`.
2.  **Trigger**: `CVDisplayNotifier.build()` calls `CVRepository.generateCV()`.
3.  **API Call**: `RemoteAIService` hits `http://localhost:3000/api/cv/generate`.
4.  **AI Logic**: Checks `backend/app/api/cv/generate/route.ts`. 
5.  **Refinement**: The backend returns specific rewritten descriptions (`analyzedExperience`).
6.  **Merging**: Flutter maps these new descriptions back into the `experience` list before showing it to the user.

---

## 🎨 How-To: Adding New CV Templates
... (Rest of the file)
