//
//  SalesDataPointModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/10/25.
//

import Foundation
@preconcurrency import FirebaseFirestore
struct DailySalesClosingPoint:Codable, Identifiable, Sendable {
    
    @DocumentID var id: String?
   
    let timeStamp:Date
    let userID:String
    let bank:Double
    let card:Double
    let cash:Double
    let deliveroo:Double
    let JHD:Double?
    let justEat:Double
    let epos:Double?
    let strip:Double?
    let total:Double
    let uberEats:Double
    
    enum CodingKeys: String, CodingKey{
        case bank, card, deliveroo, justEat, epos
        case total, uberEats, JHD, strip
        case cash = "cashFromCounter"
        case timeStamp = "timestamp"
        case userID = "userId"
        
    }
}


struct DailySalesPoint:Codable {
    let closing:DailySalesClosingPoint?
    let date:String

}
