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

    var card: String = ""
    var epos: String = ""
    var justEat: String = ""
    var uberEats: String = ""
    var bank: String = ""
    var deliveroo: String = ""

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
    var cashFloat:String = ""
    var note:String = ""

    var totalClosingSavedCash: Double?

    // Helper to safely parse optional String to Double
    private func toDouble(_ string: String?) -> Double {
        guard let s = string, !s.isEmpty else { return 0 }
        return Double(s) ?? 0
    }

    var netCashFromCounter: Double {
        let saved = totalClosingSavedCash ?? totalClosingCash
        let net = totalClosingCash - (saved + toDouble(cashFloat))
        return net
    }

    var total: Double {
        let net = netCashFromCounter
        let deliverooVal = toDouble(deliveroo)
        let bankVal = toDouble(bank)
        let uberEatsVal = toDouble(uberEats)
        let justEatVal = toDouble(justEat)
        let eposVal = toDouble(epos)
        let cardVal = toDouble(card)
        let sum = net + deliverooVal + bankVal + uberEatsVal + justEatVal + cardVal + eposVal
        return sum
    }

    func checkExistingSalesEntry() async {
        let docId = today.toString()
        do {
            let snapshot = try await db.collection("sales").document(docId)
                .getDocument()
            if let data = snapshot.data() {
                if data["opening"] is [String: Any] {

                    let opening = data["opening"] as! [String: Any]
                    totalClosingSavedCash = opening["totalCash"] as? Double ?? 0
                    isOpeningSubmitted = true
                }
                if data["closing"] is [String: Any] {

                    print("get cloasinf data")
                    isClosingSubmitted = true
                    totalClosingSavedCash = nil
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
            self.totalClosingSavedCash = self.totalOpeningCash
            
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
            "card": toDouble(card),
            "uberEats": toDouble(uberEats),
            "justEat": toDouble(justEat),
            "epos": toDouble(epos),
            "deliveroo": toDouble(deliveroo),
            "bank": toDouble(bank),
            "total": total,
            "note":note,
            "float":toDouble(cashFloat)
        ]
        
        do {
            try await services.submitClosing(userId: userId, denominations: denominations, entry: entry)
            isClosingSubmitted = true
        }catch {
            print("error: \(error)")
        }
        
    }
    
}
