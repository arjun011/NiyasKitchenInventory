//
//  UnitsRepository.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 22/08/25.
//

import Firebase
import FirebaseCore
import FirebaseFirestore
import Foundation

final class AddEditInventoryServices {

    enum GeneralError: LocalizedError {
        case nameEmpty
        case duplicateName(String)
        case firestore(String)

        var errorDescription: String? {
            switch self {
            case .nameEmpty: return "Supplier name is required."
            case .duplicateName(let name):
                return "A \(name) already exists."
            case .firestore(let msg): return msg
            }
        }
    }

    private let db = Firestore.firestore()


    // Generic function for SaveData on FireStore Collection
    func saveData<T:Codable>(collection: String, newSupplier : T) async throws -> T {

        let uuid = UUID().uuidString
        let docRef = db.collection(collection).document(uuid)
        try docRef.setData(from: newSupplier, merge: false)
        try await docRef.updateData([
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp(),
            "id": uuid,
        ])

        // 4) Read back (optional) or map locally
        let snap = try await docRef.getDocument()
        let saved = try snap.data(as: T.self)
        return saved
    }
   
    func saveInventory(inventory: InventoryItemModel) async throws -> InventoryItemModel {

        let snapshot = try await db.collection("Inventories").whereField(
            "lowercaseName", isEqualTo: inventory.lowercaseName ?? ""
        ).getDocuments()

        guard snapshot.isEmpty else { throw GeneralError.duplicateName(inventory.name) }

        let newInventory:InventoryItemModel = try await self.saveData(collection:"Inventories" , newSupplier: inventory)
        
        return newInventory
     
    }

}

//MARK: - Units -
extension AddEditInventoryServices {
    
    func fetchUnits() async throws -> [UnitsModel] {

        let snapshot = try await db.collection("Units").getDocuments()
        let units = try snapshot.documents.compactMap { doc in
            try doc.data(as: UnitsModel.self)
        }
        return units
    }
}

//MARK: - Supplier -

extension AddEditInventoryServices {
    
    func saveNewSupplier(newSupplier: SupplierModel) async throws -> SupplierModel {

        let snapshot = try await db.collection("suppliers").whereField(
            "lowercasedName", isEqualTo: newSupplier.lowercasedName ?? ""
        ).getDocuments()

        guard snapshot.isEmpty else { throw GeneralError.duplicateName(newSupplier.name) }
        let newSupplier:SupplierModel = try await self.saveData(collection:"suppliers" , newSupplier: newSupplier)
        return newSupplier
    }

    func fetchSupplierList() async throws -> [SupplierModel] {

        let snapshot = try await db.collection("suppliers").getDocuments()
        let supplierList = try snapshot.documents.compactMap { doc in
            try doc.data(as: SupplierModel.self)
        }
        return supplierList
    }

}


//MARK: - Categoery -
extension AddEditInventoryServices {
    
    func fetchCategoryList() async throws -> [InventoryCategoryModel] {

        let snapshot = try await db.collection("Categories").getDocuments()
        let categoryList = try snapshot.documents.compactMap { doc in
            try doc.data(as: InventoryCategoryModel.self)
        }
        return categoryList
    }
    
    func saveCategory(category: InventoryCategoryModel) async throws -> InventoryCategoryModel {

        let snapshot = try await db.collection("Categories").whereField(
            "lowercasedName", isEqualTo: category.lowercasedName ?? ""
        ).getDocuments()

        guard snapshot.isEmpty else { throw GeneralError.duplicateName(category.name) }

        let newCategory:InventoryCategoryModel = try await self.saveData(collection:"Categories" , newSupplier: category)
        
        return newCategory
     
    }
    
}
