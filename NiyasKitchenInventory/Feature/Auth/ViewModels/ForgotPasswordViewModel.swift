//
//  ForgotPasswordView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 13/08/25.
//

import FirebaseAuth
import Foundation

@Observable class ForgotPasswordViewModel {

    var email: String = ""
    var errorMessage: String?
    var showValidationMessage: Bool {
        get {
            !(errorMessage ?? "").isEmpty
        }
        set {}
    }
    var isLoading: Bool = false
    var isSubmitDisabled: Bool {
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return e.isEmpty || !isValidEmail(e)
    }

    func sendResetLink() async {
        guard !isSubmitDisabled, !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            errorMessage = "A password reset link has been sent to \(email)."
        } catch {
            errorMessage = mapFirebaseError(error)
        }
    }

    // MARK: - Helpers
    private func isValidEmail(_ s: String) -> Bool {
        // lightweight UI check
        s.contains("@") && s.contains(".")
    }

    private func mapFirebaseError(_ error: Error) -> String {
        let code = (error as NSError).code
        switch AuthErrorCode(rawValue: code) {
        case .userNotFound: return "No account found with that email."
        case .invalidEmail: return "The email address is invalid."
        case .networkError: return "No internet connection."
        default: return "Something went wrong. Please try again."
        }
    }

}
