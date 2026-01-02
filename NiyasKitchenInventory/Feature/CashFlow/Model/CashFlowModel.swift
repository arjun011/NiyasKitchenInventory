//
//  CashFlowModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 30/12/25.
//

import Foundation
@preconcurrency import FirebaseFirestore
import SwiftUI

struct CashFlowModel:Sendable, Codable {
    @DocumentID var id: String?
    let ammount:Float
    let description:String
    let created:Date
    let createdBy:String
    let flowType:MovementType.RawValue
    var flowColor:Color {
        get {
            return MovementType(rawValue: flowType) == .in ? Color.green : Color.red
        }
    }
}

