//
//  LoginView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 10/08/25.
//

import SwiftUI

struct LoginView: View {

    @State var loginVM = LoginViewModel()

    var body: some View {

        NavigationStack {

            ZStack {
                Color(.appBackground)
                    .ignoresSafeArea()

                VStack(alignment: .center, spacing: 30) {

                    Spacer()

                    Image(.splashLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                        .padding(.bottom, 30)

                    VStack(spacing: 0) {

                        TextField("Email", text: $loginVM.email)
                            .foregroundStyle(Color.textPrimary)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(
                                TextInputAutocapitalization.never
                            )
                            .autocorrectionDisabled()
                            .padding()

                        Divider()

                        SecureField("Password", text: $loginVM.password)
                            .foregroundStyle(Color.textPrimary)
                            .textInputAutocapitalization(
                                TextInputAutocapitalization.never
                            )
                            .autocorrectionDisabled()
                            .padding()

                    }.background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.appSecondary)
                    }.padding()

                    VStack(alignment: .trailing, spacing: 20) {

                        Button {

                            Task {
                                await self.loginVM.isLogin()
                            }

                        } label: {

                            ZStack {

                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.brandPrimary)
                                    .frame(height: 52)

                                if loginVM.isLoding {
                                    ProgressView().tint(Color.white)
                                } else {
                                    Text("Log in")
                                        .foregroundStyle(Color(.white))
                                        .font(.headline)

                                }

                            }

                        }
                        .disabled(loginVM.isLoginDisabled || loginVM.isLoding)
                        .opacity(
                            (loginVM.isLoginDisabled || loginVM.isLoding)
                                ? 0.5 : 1)

                        HStack(alignment: .center) {

                            NavigationLink {
                                ForgotPasswordView()
                            } label: {
                                Text("Forgot password?")
                                    .foregroundStyle(Color.brandPrimary)
                                    .font(.title3)
                            }

                        }

                    }.padding()

                    Spacer()
                }
            }.alert(
                loginVM.validationError,
                isPresented: $loginVM.showValidationMessage
            ) {
                Button("OK") {
                    loginVM.validationError = ""
                    loginVM.isLoding = false
                    loginVM.showValidationMessage = false
                }
            }

        }

    }
}

#Preview {
    LoginView()
}
