//
//  DailySalesViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/09/25.
//

import Foundation
import Firebase
@MainActor
@Observable final class DailySalesViewModel {
    
    private let services:DailySalesServices
    
    init(service:DailySalesServices = DailySalesServices()) {
        self.services = service
    }
    
    private let db = Firestore.firestore()
    let today: Date = .now

    var openingDenominationFields: [DenominationField] =
        DenominationField.defaultFields()
    var closingDenominationFields: [DenominationField] =
        DenominationField.defaultFields()

    var card: Double = 0
    var justEat: Double = 0
    var uberEats: Double = 0
    var bank: Double = 0
    var deliveroo: Double = 0

    var isOpeningSubmitted = false
    var isClosingSubmitted = false

    var totalOpeningCash: Double {
        openingDenominationFields.reduce(0) {
            $0 + ($1.value * Double($1.count ?? 0))
        }
    }

    var totalClosingCash: Double {
        closingDenominationFields.reduce(0) {
            $0 + ($1.value * Double($1.count ?? 0))
        }
    }

    var netCashFromCounter: Double {
        totalClosingCash - totalOpeningCash
    }
    var total: Double {
        netCashFromCounter + deliveroo + bank + uberEats + justEat + card
    }

    func checkExistingSalesEntry() async {
        let docId = today.toString()
        do {
            let snapshot = try await db.collection("sales").document(docId)
                .getDocument()
            if let data = snapshot.data() {
                if data["opening"] is [String: Any] {

                    print("get opeing data")

                    isOpeningSubmitted = true
                }
                if data["closing"] is [String: Any] {

                    print("get cloasinf data")
                    isClosingSubmitted = true
                }
            }
        } catch {
            print("Error checking entry: \(error)")
        }
    }
    
    
    func submitOpening(userId: String) async  {
        
        do {
            
            let denominations = Dictionary(
                uniqueKeysWithValues: openingDenominationFields.map {
                    ("\($0.value)", $0.count)
                })
            
            let entry: [String: Any] = [
                "userId": userId,
                "timestamp": Timestamp(date: today),
                "denominations": denominations,
                "totalCash": totalOpeningCash,
            ]
            
            try await services.submitOpening(userId: userId, denominations: denominations, entry: entry)
            isOpeningSubmitted = true
            
        }catch {
            print(error)
        }
        
    }


    func submitClosing(userId: String) async  {
        
        let denominations = Dictionary(
            uniqueKeysWithValues: closingDenominationFields.map {
                ("\($0.value)", $0.count)
            })
        
        let entry: [String: Any] = [
            "userId": userId,
            "timestamp": Timestamp(date: Date()),
            "denominations": denominations,
            "cashFromCounter": totalClosingCash,
            "card": card,
            "uberEats": uberEats,
            "justEat": justEat,
            "deliveroo": deliveroo,
            "bank": bank,
            "total": total,
        ]
        
        do {
            try await services.submitClosing(userId: userId, denominations: denominations, entry: entry)
            isClosingSubmitted = true
        }catch {
            print("error: \(error)")
        }
        
    }
    
}
