//
//  AllergensListView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 29/01/26.
//

import SwiftUI

struct AddAllergensDetailsView: View {

    @State var vm:AllergensDishViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {

        Form {
            Section("Dish") {
                TextField("Dish name", text: $vm.allergens.dishName)
            }

            Section("Allergens") {

                List($vm.allergens.allergesList) { $allergence in
                    HStack {
                        Text(allergence.label)
                        Spacer()
                        Image(allergence.label)
                            .resizable()
                            .frame(width: 50, height: 55, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                        if allergence.value {
                            Image(systemName: "checkmark.diamond.fill")
                                .foregroundStyle(.red)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print("click..")
                        allergence.value.toggle()
                    }
                }

            }
        }.navigationTitle("Dish Allergens")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {

                    Button(vm.allergens.id == nil ? "Save" : "Update") {
                        Task { await vm.saveOrUpdate() }
                    }.tint(Color.brandPrimary)
                        .disabled(vm.allergens.dishName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                }
            }
            .alert(vm.validationMessage, isPresented: $vm.showValidation) {
                Button("Ok") {
                    dismiss()
                }
            }
    }

}

#Preview {

    NavigationStack {
        AddAllergensDetailsView(vm: AllergensDishViewModel())
    }

}
