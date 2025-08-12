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
        ZStack {
            Color(.brandNavy)
                .ignoresSafeArea()

            VStack(alignment: .center, spacing: 30) {

                Spacer()

                Image(.whiteLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .padding(.bottom, 30)

                VStack(spacing: 0) {

                    TextField("Email", text: $loginVM.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                        .autocorrectionDisabled()
                        .padding()

                    Divider()

                    SecureField("Password", text: $loginVM.password)
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                        .autocorrectionDisabled()
                        .padding()
                    
                }.background(
                    Color.white, in: RoundedRectangle(cornerRadius: 10)
                )
                .padding()

                VStack(alignment: .trailing, spacing: 20) {

                    Button {
                        
                        Task {
                            await self.loginVM.isLogin()
                        }
                        
                    } label: {

                        if loginVM.isLoding {
                            ProgressView().tint(Color.brandNavy)
                        } else {
                            Text("Log in")
                                .foregroundStyle(Color(.brandNavy))
                                .font(.headline)

                        }

                    }.padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.white,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                        .disabled(loginVM.isLoginDisabled || loginVM.isLoding)
                        .opacity((loginVM.isLoginDisabled || loginVM.isLoding ) ? 0.5 : 1)

                    HStack(alignment: .center) {
                        Button {

                        } label: {
                            Text("Forgot password?")
                                .foregroundStyle(.white)
                                .font(.footnote)
                        }
                    }

                }.padding()

                Spacer()
            }
        }.alert(
            loginVM.validationError, isPresented: $loginVM.showValidationMessage
        ) {
            Button("OK") {
                loginVM.validationError = ""
                loginVM.isLoding = false
                loginVM.showValidationMessage = false
            }
        }
    }
}

#Preview {
    LoginView()
}
