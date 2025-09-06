//
//  CreatePOViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import Foundation

@Observable final class CreatePOViewModel {

    var supplierName: String = ""
    var email: String = ""
    var contact: String = ""
    var note: String = ""
    var expectedDeliveryDate: Date = Date()
    var showSupplierList: Bool = false
    var supplierList: [SupplierModel] = []
    var selectedSupplierID: String? = nil
    var task: Task<Void, Never>?
    var selectedSupplier: SupplierModel? {
        didSet {
            email = selectedSupplier?.email ?? ""
            contact = selectedSupplier?.phone ?? ""
            supplierName = selectedSupplier?.name ?? ""
            selectedSupplierID = selectedSupplier?.id.uuidString

            task?.cancel()

            task = Task {
                await self.getInventoryItemsBy(
                    suuplierId: selectedSupplierID ?? "")
            }

        }
    }

    var supplierItemsList: [POLineModel] = []
    var selections = Set<POLineModel.ID>()
    private let service = POServices()
    private let inventoryServices: AddEditInventoryServices =
        AddEditInventoryServices()

    var orderItemList: [POLineModel] {
        let selectedItems = supplierItemsList.filter {
            selections.contains($0.id)
        }
        return selectedItems
    }

    deinit {
        print("sequence driven example deinit")
        task?.cancel()
    }

    func fetchSupplierList() async {

        do {
            self.supplierList = try await inventoryServices.fetchSupplierList()
        } catch {
            print(error.localizedDescription)
        }

    }

    func getInventoryItemsBy(suuplierId: String) async {

        do {
            let items = try await service.getInventoriesBy(
                supplierID: suuplierId)
            
            self.supplierItemsList = items.compactMap({ item in
                var selectedItem = item
                selectedItem.orderedQty = (item.lowStockThreshold ?? 0) * 2
                
                return selectedItem
                
            })
            
            
            self.selections = []
        } catch {
            print(error)
        }
    }

    func saveDraftBy(userID: String) async {

        let draftOrder = POModel(
            supplierId: selectedSupplierID ?? "",
            supplierName: supplierName,
            supplierEmail: email,
            status: POStatus.draft.id,
            expectedDate: expectedDeliveryDate,
            notes: note,
            createdAt: Date(),
            createdBy: userID,
            sentAt: nil,
            receivedAt: nil,
            updatedAt: Date())

        do {

            try await service.saveDraft(
                orderDraft: draftOrder, lines: self.orderItemList)
            print("Updated succesfully")
        } catch {
            print(error)
        }
    }

}
