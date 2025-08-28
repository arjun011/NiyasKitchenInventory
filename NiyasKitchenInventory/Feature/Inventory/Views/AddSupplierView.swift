//
//  AddSupplierView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 23/08/25.
//

import SwiftUI

struct AddSupplierView: View {

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var contactNumber: String = ""
    var saveSupplier: (SupplierModel) -> Void
    @Environment(\.dismiss) private var dismiss
    private var isValid: Bool {
        let namaV = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return namaV.isEmpty
    }

    var body: some View {

        VStack {

            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        
                    TextField("Contact number", text: $contactNumber)
                        .keyboardType(.phonePad)
                        
                } header: {
                    Text("Add Supplier")
                }
            }
            .autocorrectionDisabled()
            .foregroundStyle(Color.brandPrimary)
            .formStyle(.grouped)

            Button {

                saveSupplier(
                    .init(
                        name: self.name, lowercasedName: self.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), phone: self.contactNumber,
                        email: self.email))
                
                dismiss()

            } label: {
                Text("Save")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.brandPrimary)
                    }

            }.padding()
                .disabled(isValid)
                .opacity(isValid ? 0.5 : 1)

            Spacer()
        }

    }
}

#Preview {

    NavigationStack {
        AddSupplierView { _ in

        }
    }
}
