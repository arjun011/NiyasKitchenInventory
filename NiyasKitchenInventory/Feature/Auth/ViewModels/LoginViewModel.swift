//
//  LoginViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 10/08/25.
//

import Combine
import FirebaseAuth
import Foundation

@Observable final class LoginViewModel {

    var email: String = ""
    var password: String = ""
    var validationError: String = ""
    var isLoding: Bool = false
    var showValidationMessage: Bool {
        get {
            !validationError.isEmpty
        }
        set {}
    }

    var isLoginDisabled: Bool {

        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return email.isEmpty || password.isEmpty || !self.isValidEmail(e)
    }

    // Async login
    func isLogin() async {

        guard !isLoginDisabled else {
            return
        }
        self.isLoding = true

        defer {
            self.isLoding = false
        }
        
        do {

            let user = try await Auth.auth().signIn(
                withEmail: email, password: password)

            print("Email = \(user.user.email ?? "")")
            print("UserID = \(user.user.uid)")
            print("Dispaly name = \(user.user.displayName ?? "")")
            
            self.validationError = ""

        } catch {
            self.validationError = self.mapFirebaseError(error)
        }

    }

    // MARK: - Helpers
    private func isValidEmail(_ s: String) -> Bool {
        // lightweight UI regex
        let regex = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: s)
    }

    private func mapFirebaseError(_ error: Error) -> String {
        let code = (error as NSError).code

        switch AuthErrorCode(rawValue: code) {
        case .wrongPassword, .userNotFound:
            return "Email or password is incorrect."
        case .userDisabled:
            return "Your account has been disabled. Contact your manager."
        case .networkError:
            return "No internet. Check your connection and try again."
        case .tooManyRequests:
            return "Too many attempts. Try again in a few minutes."
        default: return "Something went wrong. Please try again."
        }

    }
}
