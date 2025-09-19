//
//  UnitsModel.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 19/09/25.
//

import Foundation
@testable import NiyasKitchenInventory

extension UnitsModel {
    
    static func mock(id:String = UUID().uuidString , name:String = "name") -> UnitsModel {
        
        UnitsModel(id:id , name: name)
        
    }
    
}
