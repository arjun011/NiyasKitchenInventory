//
//  AddMovementViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 29/08/25.
//

import Foundation

@Observable final class AddMovementViewModel {
    
    
    
    var quantity:String = ""
    var typesOfMovement:MovementType = .in
    var selectedSupplier:SupplierModel? = nil
    var suppliers:[SupplierModel] = []
    var note:String = ""
    private let inventoryService = AddEditInventoryServices()
    private let service = MovementsServices()
    
    var isValidate:Bool {
        
        if (Double(quantity) ?? 0) <= 0 { return false}
        
        return true
    }
    
    
    
    func getSupplierList() async {
        
        do {
            self.suppliers = try await inventoryService.fetchSupplierList()
            print("Suppliers count :\(suppliers.count)")
            
        }catch {
            print(error)
        }
    }
    
    func saveMovement(inventory: InventoryItemModel,profile: UserProfile?) async {
     
        let movement = MovementModel(itemId: inventory.id.uuidString,
                                     itemName: inventory.name,
                                     type: self.typesOfMovement.rawValue,
                                     quantity: Double(self.quantity) ?? 0,
                                     unitName: inventory.unit,
                                     unitId: inventory.name,
                                     note: self.note,
                                     supplierID: inventory.supplierId,
                                     supplierName: inventory.supplierName,
                                     createdAt: Date(),
                                     createdBy: profile?.uid ?? "N/A")
        
        
        do {
           let _ = try await service.saveMovement(movement: movement)
            print("Movement Saved")
        }catch {
            print(error.localizedDescription)
        }
    }
    
}
