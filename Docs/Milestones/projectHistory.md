
# 📜 Project History – NiyasKitchenInventory

## Phase 1: Project Setup
- **Repo Name**: `NiyasKitchenInventory`
- **Architecture**: MVVM + SwiftUI + Swift Concurrency
- **Backend**: Firebase (Auth + Firestore)
- **Platform**: iOS, single restaurant, light mode only
- **Design System**:
  - Primary color: `#1B4066` (BrandPrimary)
  - Secondary tint: `#E6EEF7` (BrandTint)
  - TextPrimary: `#1B4066`
  - TextSecondary: `#5C6B80`
  - Success: `#28A745`
  - Error: `#E63946`

---

## Phase 2: Authentication Milestone

### 1. LoginView
- Direct colors from `Assets.xcassets` (no inline hex)
- Disabled state when email/password empty or invalid
- Async login with Firebase Auth
- **Final Files**:
  - `LoginViewModel.swift`
  - `LoginView.swift`

### 2. ForgotPasswordView
- Matching style to LoginView (Light Mode Brand Navy)
- Single email field with reset link functionality
- Generic success copy for privacy
- **Final Files**:
  - `ForgotPasswordViewModel.swift`
  - `ForgotPasswordView.swift`

### 3. Refactoring for Testability
- Introduced `AuthServiceProtocol` and `FirebaseAuthService`
- ViewModels accept injected `AuthServiceProtocol` for unit testing
- Ready for `FakeAuthService` in test target

---

## Phase 3: GitHub Workflow

- **Branch strategy**:
  - `main`: stable
  - `feature/<name>`: one per milestone
- **Milestone docs** in `/Docs/milestones`
- **PR template** and **branch protection** enabled
- Option to integrate **SwiftLint** + GitHub Actions CI

---

## Phase 4: Approved Designs
- **Login Screen**:
  - Centered logo
  - Grouped email/password fields
  - Primary button + "Forgot password" link
- **Forgot Password Screen**:
  - Logo + title
  - Helper text
  - Email field + primary button
  - "Back to Login" link

---

## Phase 5: Next Milestone – Dashboard MVP
- **Purpose**: Inventory snapshot + quick actions
- **Planned Features**:
  - Greeting with user name
  - Summary cards:
    - Total items
    - Low stock items
    - Today's movements
  - Quick actions: Stock In, Stock Out, View All Inventory
- **Firestore queries**:
  - `items` → count all
  - `items` → count low stock
  - `stockMovements` → filter today
- **Planned Files**:
  - `DashboardView.swift`
  - `DashboardViewModel.swift`
  - `DashboardSummaryCard.swift`
- **Test Plan**: ViewModel unit tests with mock Firestore service

---

## ✅ Completed
- Repo setup with MVVM & Swift Concurrency
- Firebase Auth integration
- Login & Forgot Password screens (final design + code)
- Refactoring for unit testing
- GitHub workflow plan

---

## ⏭ Next Steps
- Create `feature/dashboard-mvp` branch
- Add `/Docs/milestones/dashboard_milestone_plan.md`
- Lock design via high-fidelity mockup
- Implement DashboardView + ViewModel
- Unit test ViewModel with mock Firestore
