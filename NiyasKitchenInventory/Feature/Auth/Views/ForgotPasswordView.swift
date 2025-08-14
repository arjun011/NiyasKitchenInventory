//
//  ForgotPasswordView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 13/08/25.
//

import SwiftUI

struct ForgotPasswordView: View {

    @State var vm = ForgotPasswordViewModel()

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(
                alignment: .leading, spacing: 20,
                content: {

                    Text(
                        "Enter the email associated with your account. We'll send you a reset link."
                    )
                    .font(.body)
                    .foregroundStyle(Color("TextSecondary"))

                    TextField("Email", text: $vm.email)
                        .padding()
                        .foregroundStyle(Color.textPrimary)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.appSecondary)
                        }

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.brandPrimary)
                            .frame(height: 52)
                        Button {
                            Task {
                                await vm.sendResetLink()
                            }
                        } label: {
                            Text("Reset Password")
                                .foregroundStyle(Color(.white))
                                .font(.headline)
                        }

                    }.disabled(vm.isSubmitDisabled || vm.isLoading)
                        .opacity(
                            (vm.isSubmitDisabled || vm.isLoading)
                                ? 0.5 : 1)

                }
            ).padding()
                .navigationTitle("Reset Password")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {

                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .tint(Color.appPrimary)
                        }

                    }
                }

        }.alert(
            vm.errorMessage ?? "",
            isPresented: $vm.showValidationMessage
        ) {
            Button("OK") {

            }
        }

    }
}

#Preview {

    NavigationStack {
        ForgotPasswordView()
    }

}
