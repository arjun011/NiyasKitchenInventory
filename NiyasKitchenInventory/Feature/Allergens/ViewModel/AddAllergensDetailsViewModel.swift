//
//  AllergensDishViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 09/02/26.
//

import Foundation
@MainActor
@Observable final class AllergensDishViewModel {
    
    var allergens:AllergensModel
    var validationMessage:String = ""
    var showValidation:Bool = false
    private let services:AllergenceDishProtocol
    
    
    init(allergens:AllergensModel = AllergensModel(allergesList: AllergensListModel.defaultValue()), services: AllergenceDishProtocol = AllergensDishServices()) {
        self.services = services
        self.allergens = allergens
        
    }
    
    func saveOrUpdate() async {
        if allergens.id == nil {
            await saveAllergens()
        } else {
            await updateAllergens()
        }
    }

    func saveAllergens() async  {
            
        do {
            try await self.services.saveAllergens(allergens: allergens)
            self.showValidation(msg: "Allergen details successfully saved.")
        }catch {
            self.showValidation(msg: error.localizedDescription)
        }
        
    }
    
    
    func updateAllergens() async  {
            
        do {
            try await self.services.updateAllergensDetails(allergens: allergens)
            self.showValidation(msg: "Allergen details update successfully.")
        }catch {
            self.showValidation(msg: error.localizedDescription)
        }
        
    }
    
    func showValidation(msg:String) {
        self.validationMessage = msg
        self.showValidation = true
    }
}
