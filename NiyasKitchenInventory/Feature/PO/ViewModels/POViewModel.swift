//
//  POViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 07/09/25.
//

import Foundation
import Firebase

@MainActor @Observable final class POViewModel {

    private let services = POServices()
    var fetchStatus:POStatus = .all
    var poList:[POModel] = []
    
    func getPurachaseOrderOn(status: POStatus) async {
        
        do {
            poList  = try await services.fetchPurchaseOrderListOn(status: fetchStatus)
            print(poList)
        }catch{
            print(error)
        }
        
    }
    
   
    
}
