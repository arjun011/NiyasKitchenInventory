//
//  CreatePOViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import Foundation

@Observable final class CreatePOViewModel {

    var supplierName:String = ""
    var email: String = ""
    var contact: String = ""
    var note: String = ""
    var expectedDeliveryDate: Date = Date()
    var showSupplierList: Bool = false
    var supplierList:[SupplierModel] = []
    var selectedSupplierID:String? = nil
    var task: Task<Void, Never>?
    var selectedSupplier:SupplierModel? {
        didSet {
            email = selectedSupplier?.email ?? ""
            contact = selectedSupplier?.phone ?? ""
            supplierName = selectedSupplier?.name ?? ""
            selectedSupplierID = selectedSupplier?.id.uuidString
            
           task?.cancel()
            
           task = Task {
                await self.getInventoryItemsBy(suuplierId: selectedSupplierID ?? "")
            }
            
        }
    }
    
    var supplierItemsList:[POItemsModel] = []
    var selections = Set<POItemsModel.ID>()
    private let service = POServices()
    private let inventoryServices:AddEditInventoryServices = AddEditInventoryServices()
    
    var orderItemList:[POItemsModel] {
        
        get {
            let selectedItems = supplierItemsList.filter {
                selections.contains($0.id)
            }
            return selectedItems
        }
    }
    
    deinit {
        print("sequence driven example deinit")
        task?.cancel()
    }
    
    func fetchSupplierList() async {
    
        do {
            self.supplierList = try await inventoryServices.fetchSupplierList()
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getInventoryItemsBy(suuplierId:String) async {
        
        do {
            self.supplierItemsList =  try await service.getInventoriesBy(supplierID: suuplierId)
            self.selections = []
        }catch {
            print(error)
        }
        
    }
}
