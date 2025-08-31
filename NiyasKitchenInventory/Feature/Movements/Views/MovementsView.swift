//
//  MovementsView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/08/25.
//

import SwiftUI

struct MovementsView: View {

    private enum Route: Hashable {
        case addMovement(item: InventoryItemModel)
    }

    @State private var vm = MovementsViewModel()
    @State private var navPath: [Route] = []

    var body: some View {

        NavigationStack(path: $navPath) {

            ZStack {
                
                VStack {

                    Picker("Types", selection: $vm.filteredType) {

                        ForEach(MovementType.allCases) {
                            type in
                            Text(type.rawValue).tag(type)
                        }

                    }.pickerStyle(.segmented)
                        .padding(.horizontal)

                    
                    List(vm.filteredMovementList) { movement in

                        MovementListRow(movement: movement)

                    }

                }.task {
                    await vm.getMovementList()
                }.sheet(
                    isPresented: $vm.showInventoryList,
                    content: {
                        SelectItemListView { selectedInventory in
                            print(selectedInventory.name)
                            vm.showInventoryList = false 
                            navPath.append(.addMovement(item: selectedInventory))

                        }
                    }
                )
                .navigationTitle("Movements")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    
                    ToolbarItemGroup {
                        Menu {
                            Picker("Range", selection: $vm.range) {
                                ForEach(RangeFilter.allCases) { r in Text(r.rawValue).tag(r) }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                Text(vm.range.rawValue)
                            }
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(.thinMaterial, in: Capsule())
                        }

                        
                        Button {
                            vm.showInventoryList.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .tint(Color.brandPrimary)
                        }

                    }
                }.navigationDestination(for: Route.self) { screenEnum in
                    
                    MovementsView.navigate(to: screenEnum)
                    
                }.blur(radius: vm.isLoading ? 1 : 0)
                .disabled(vm.isLoading)

                
                if vm.isLoading {
                    ProgressView()
                        .tint(Color.brandPrimary)
                }
                
            }
        }

    }
}

extension MovementsView {

    private static func navigate(to screen: Route) -> some View {

        switch screen {
        case let .addMovement(item: item):
            AddMovementView1(inventory: item)
        }
    }
}

#Preview {
    NavigationStack {
        MovementsView()
    }

}
