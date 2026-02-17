//
//  AllergensModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 09/02/26.
//

import Foundation
@preconcurrency import FirebaseFirestore
import SwiftUI

struct AllergensModel:Codable, Sendable, Identifiable {
    
    @DocumentID var id:String?
    var dishName:String = ""
    var dishNameNormalized:String?
    var allergesList:[AllergensListModel] = []
}
