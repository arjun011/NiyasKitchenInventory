//
//  AddEditInventoryViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/08/25.
//

import Firebase
import FirebaseCore
import FirebaseFirestore
import Foundation

@MainActor @Observable final class AddEditInventoryViewModel {

    var isLoading:Bool = false
    var name: String = ""
    var sku: String = ""
    var quantity: Double = 1
    var lowStockThreshold: Double = 1
    var note: String = ""

    var units: [UnitsModel] = []
    var selectedUnit: UnitsModel? = nil

    var showAddCategory: Bool = false
    var categoryName: String = ""
    var selectedCategory: InventoryCategoryModel? = nil
    var categories: [InventoryCategoryModel] = []

    var showAddSupplier: Bool = false
    var suppliers: [SupplierModel] = []
    var selectedSupplier: SupplierModel? = nil

    var errorMessage:String? = nil
    var showError:Bool = false
    
    var isValid: Bool {
 
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty { return false }
        
        if quantity <= 0 { return false }
        if lowStockThreshold <= 0 { return false }
        if selectedUnit == nil { return false }
        if selectedCategory == nil { return false }
        if selectedSupplier == nil {return false}
       
        
        return true

    }

    private let service = AddEditInventoryServices()

    func getUnits() async {

        do {
            self.units = try await service.fetchUnits()
            self.selectedUnit = self.units.first
        } catch {
            self.displayErrorMessage(message: error.localizedDescription)
        }
    }
    
    func resetValues() {
        self.name = ""
        self.sku = ""
        self.quantity = 1
        self.lowStockThreshold = 1
        self.note = ""
    }
    
    func saveInventory() async {
        
        guard !isLoading else { return }
        self.isLoading = true
        
        defer {
            self.isLoading = false
        }
        
        let inventory = InventoryItemModel(name: name,
                                           sku: sku,
                                           quantity: quantity,
                                           unit: selectedUnit?.name ?? "",
                                           supplierName: (selectedSupplier?.name ?? ""),
                                           supplierId: (selectedSupplier?.id.uuidString ?? UUID().uuidString),
                                           lowercaseName: name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ,
                                           lowStockThreshold: lowStockThreshold,
                                           updatedAt: Date(),
                                           note: note,
                                           categoryName:selectedCategory?.name)
        
        do {
            
            let _ =  try await service.saveInventory(inventory: inventory)
            self.displayErrorMessage(message: "Item added successfully")
            self.resetValues()

        }catch {
            self.displayErrorMessage(message: error.localizedDescription)
        }
    }
    
}

//MARK: - Category -

extension AddEditInventoryViewModel {

     func getCategoryList() async {
        do {
            self.categories = try await service.fetchCategoryList()
        } catch {
            self.displayErrorMessage(message: error.localizedDescription)
        }
    }

    func saveCategory(category: InventoryCategoryModel) async {

        guard !isLoading else { return }
        self.isLoading = true
        
        defer {
            self.isLoading = false
        }

        do {

            let newCategory: InventoryCategoryModel =
                try await service.saveCategory(category: category)
            self.selectedCategory = newCategory
            self.categories.append(newCategory)
            self.categoryName = ""

        } catch {
            
            self.displayErrorMessage(message: error.localizedDescription)

        }

    }

}

//MARK: - Supplier  -

extension AddEditInventoryViewModel {

    func getSupplierList() async {
        do {
            self.suppliers = try await service.fetchSupplierList()
        } catch {
            self.displayErrorMessage(message: error.localizedDescription)

        }
    }

    func saveSupplier(supplier: SupplierModel) async {

        guard !isLoading else { return }
        self.isLoading = true
        
        defer {
            self.isLoading = false
        }

        do {
            let newSupplier = try await service.saveNewSupplier(
                newSupplier: supplier)
            self.suppliers.append(newSupplier)
            self.selectedSupplier = newSupplier
        } catch {
            
            self.displayErrorMessage(message: error.localizedDescription)
        }

    }

}


//MARK: - Error message -
extension AddEditInventoryViewModel {
         
    func displayErrorMessage(message:String) {
        self.showError = true
        self.errorMessage = message
    }
}

