//
//  POViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 07/09/25.
//

import Foundation
import Firebase

@Observable final class POViewModel {


    private let services = POServices()
    var fetchStatus:POStatus = .all
    
    func getPurachaseOrderOn(status: POStatus) async {
        
        do {
            var poList  = try await services.fetchPurchaseOrderListOn(status: fetchStatus)
            print(poList)
        }catch{
            print(error)
        }
        
    }
    
   
    
}
