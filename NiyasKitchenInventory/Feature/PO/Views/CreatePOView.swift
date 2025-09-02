//
//  CreatePOView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import SwiftUI

struct CreatePOView: View {
    
    @State var email:String = ""
    @State var contact:String = ""
    @State var note:String = ""
    
    @State var expectedDeliveryDate:Date = Date()
    
    var body: some View {
        
        ZStack {
            Form {
                Section {
                    Button {
                        
                    } label: {
                        
                        HStack(alignment: .center) {
                            
                            Label("Select Supplier", systemImage: "person.2.fill")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                        }.tint(Color.brandPrimary)

                        TextField("Email", text: $email)  .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        
                        TextField("Contact (Optional)", text: $contact)
                            .keyboardType(.phonePad)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        
                    }

                } header: {
                    Text("SUPPLIER")
                }
                
                Section {
                    DatePicker("Delivery Date", selection: $expectedDeliveryDate, displayedComponents: .date)
                        .tint(Color.brandPrimary)
                } header: {
                    Text("EXPECTED DATE")
                }

                Section {
                    
                    ForEach(0..<5, id: \.self) { number in
                        Text("\(number)")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("Add Item", systemImage: "text.badge.plus")
                            .listItemTint(Color.brandPrimary)
                    }

                    
                } header: {
                    Text("Items")
                }

                
                Section {
                    TextField("Delivery Instruction, Contact, etc..", text: $note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                } header: {
                    Text("Note (Optional)")
                }

                
            }
            
            .navigationTitle("New Purchase Order")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Save Draft")
                            .foregroundStyle(Color.brandPrimary)
                    }

                }
            }
        }
        
    }
}

#Preview {
    
    NavigationStack {
        CreatePOView()
    }
    
    
}
