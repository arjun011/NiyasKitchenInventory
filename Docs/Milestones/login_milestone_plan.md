
# Login Module Milestone – NiyasKitchenInventory

## 0) Configure Firebase Project for App
**Labels:** `setup`, `backend`, `auth`  
**Branch:** `setup/firebase-config`

**Checklist**
- [✅] Create a new Firebase project named **NiyasKitchenInventory** in Firebase Console  
- [✅] Add iOS app in Firebase (use your app’s bundle ID)  
- [✅] Download `GoogleService-Info.plist` and add it to the Xcode project (main app target)  
- [✅] Enable **Email/Password Authentication** in Firebase Authentication  
- [✅] Create **Firestore Database** (start in test mode for initial dev)  
- [✅] Create `/users` collection manually or via seed script for test accounts  
- [✅] Add sample admin and stock manager user accounts for development  
- [✅] Enable Firebase Authentication Emulator for local testing (optional)  

**Acceptance Criteria**
- App builds and compiles with Firebase SDK installed  
- Test account credentials can sign in successfully  
- Firestore is accessible from the app for authenticated users  

---

## 1) Login UI (SwiftUI)
**Labels:** `feature`, `ui`, `auth`  
**Branch:** `feature/login-ui`

**Checklist**
- [✅] Add Login screen with official logo, Email, Password, “Log In” button  
- [✅] Disable button until inputs valid (email format + non-empty password)  
- [✅] Keyboard types + return key behavior (email → password)  
- [✅] Loading state inside button (spinner), inputs disabled while submitting  
- [✅] “Forgot Password?” link  
  

**Acceptance Criteria**
- User can enter email/password, button enables only when valid  
- Loading state visible on submit; finishes on success/error  
- Error messages are friendly and concise  
- Works in light/dark mode  

---

## 2) Session Gate (App Start)
**Labels:** `feature`, `auth`  
**Branch:** `feature/session-gate`

**Checklist**
- [✅] App start checks current session  
- [✅] If authed → go to Dashboard  
- [✅] If not authed/expired → show Login  
  

**Acceptance Criteria**
- No “flash” of login on warm start when already signed in  
- Offline with valid session enters app with banner; without session shows login  
---

## 3) Forgot Password Flow
**Labels:** `feature`, `auth`, `ui`  
**Branch:** `feature/forgot-password`

**Checklist**
- ✅ Forgot Password screen with email field  
- ✅ Send reset link via Auth service  
- ✅ Neutral success message regardless of account existence  
- ✅ Error state only for network issues  

**Acceptance Criteria**
- Entering any email shows neutral success message  
- Reset email is received for valid accounts  
- No disclosure if an email exists  

---

## 4) Login Module Tests
**Labels:** `test`, `quality`  
**Branch:** `test/login-module`

**Checklist**
- [ ] Unit tests: validators (email, password)  
- [ ] Unit tests: AuthService success/failure  
- [ ] Unit tests: session gate routing  
 

**Acceptance Criteria**
- All tests pass locally  
- Basic coverage for critical login paths  
