//
//  DishListView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 12/02/26.
//

import SwiftUI

struct DishListView: View {
    
    @State var vm = DishListViewModel()
    
    var body: some View {
        
        VStack {
            List(vm.filteredDishes) { dish in
                VStack {
                    
                    NavigationLink {
                        AddAllergensDetailsView(vm: AllergensDishViewModel(allergens: dish))
                    } label: {
                        Text(dish.dishName)
                    }
                }
            }.task {
                await vm.getDishList()
            }
            
            .navigationTitle("Allergense Dishes")
            .toolbar {
                
                NavigationLink {
                    AddAllergensDetailsView(vm: AllergensDishViewModel())
                } label: {
                    Image(systemName: "plus.circle")
                        .tint(Color.brandPrimary)
                }

            }.searchable(
                text: $vm.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("Search items by name")
            )
            .layoutPriority(1)
            
        }
        
        
    }
}

#Preview {
    
    NavigationStack {
        DishListView()
    }
    
}
