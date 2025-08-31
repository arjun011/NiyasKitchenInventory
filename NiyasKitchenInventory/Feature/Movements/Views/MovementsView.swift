//
//  MovementsView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/08/25.
//

import SwiftUI

struct MovementsView: View {

    private enum Route1: Hashable {
        case addMovement(item: InventoryItemModel)
    }

    @State private var vm = MovementsViewModel()
    @State private var navPath: [Route1] = []

    var body: some View {

        NavigationStack(path: $navPath) {

            VStack {

                List(vm.movementList) { movement in

                    HStack(
                        alignment: .top, spacing: 10,
                        content: {

                            Image(systemName: movement.mType.icon)
                                .foregroundStyle(movement.mType.tint)
                                .font(.title)

                            
                            VStack(alignment: .leading) {
                                
                                HStack(
                                    alignment: .firstTextBaseline, spacing: 4
                                ) {

                                    Text(movement.itemName)
                                        .fontWeight(.semibold)

                                    Text(movement.displayQuantityFormate)
                                        .foregroundStyle(Color.secondary)
                                        .font(.footnote)

                                    Spacer()

                                    Text(
                                        movement.createdAt.formatted(
                                            date: .long, time: .omitted)
                                    )
                                    .foregroundStyle(Color.secondary)
                                    .font(.footnote)


                                }.frame(maxWidth: .infinity)
                                
                                if movement.mType == .in, movement.supplierName != nil {
                                    
                                    Label(movement.supplierName ?? "", systemImage: "person.2")
                                        .listItemTint(Color.brandPrimary)
                                        .font(.callout)
                                }

                                if let note = movement.note, !note.isEmpty {
                                    Text("• \(note)")
                                        .font(.footnote)
                                        .lineLimit(3, reservesSpace: false)
                                }
                                
                            }
                            
                            
                        })

                }.task {
                    await vm.getMovementList()
                }

            }.sheet(
                isPresented: $vm.showInventoryList,
                content: {
                    SelectItemListView { selectedInventory in
                        print(selectedInventory.name)

                        navPath.append(.addMovement(item: selectedInventory))

                    }
                }
            )
            .navigationTitle("Movements")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.showInventoryList.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .tint(Color.brandPrimary)
                    }

                }
            }.navigationDestination(for: Route1.self) { screenEnum in

                MovementsView.navigate(to: screenEnum)
            }

        }

    }
}

extension MovementsView {

    private static func navigate(to screen: Route1) -> some View {

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
