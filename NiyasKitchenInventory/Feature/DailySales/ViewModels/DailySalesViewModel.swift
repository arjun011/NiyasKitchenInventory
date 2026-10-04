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
    var JHD: String = ""
    var strip: String = ""
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
        let JHDVal = toDouble(JHD)
        let eposVal = toDouble(epos)
        let cardVal = toDouble(card)
        let stripVal = toDouble(strip)
        let sum = net + deliverooVal + bankVal + uberEatsVal + justEatVal + cardVal + eposVal + JHDVal + stripVal
        return sum
    }

    func checkExistingSalesEntry() async {
        let docId = today.toString()
        
    
        do {
            let snapshot = try await db.collection("sales").document(docId)
                .getDocument()
            
            print("get last closing data")
            self.openingDenominationFields = try await self.fetchLastClosingDenominations() ??  DenominationField.defaultFields()
            
            if let data = snapshot.data() {
                if data["opening"] is [String: Any] {

                    let opening = data["opening"] as! [String: Any]
                    totalClosingSavedCash = opening["totalCash"] as? Double ?? 0
                    isOpeningSubmitted = true
                    
                }
                if data["closing"] is [String: Any] {

                    
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
            "closingCashFromCounter": totalClosingCash,
            "cashFromCounter": netCashFromCounter,
            "card": toDouble(card),
            "uberEats": toDouble(uberEats),
            "justEat": toDouble(justEat),
            "JHD": toDouble(JHD),
            "strip": toDouble(strip),
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
    
    
    
    func fetchLastClosingDenominations() async throws -> [DenominationField]? {
        let snapshot = try await db.collection("sales")
            .order(by: "date", descending: true)
            .limit(to: 7)
            .getDocuments()
        
        
        for doc in snapshot.documents {
            if let closing = doc.data()["closing"] as? [String: Any],
               let denominationsAny = closing["denominations"] as? [String: Int?] {
        

                // Build denominations preserving face value and assigning counts from Firestore
                let denominations: [DenominationField] = [
                    .init(label: "£50", value: 50.0, count: denominationsAny["50.0"] ?? 0),
                    .init(label: "£20", value: 20.0, count: denominationsAny["20.0"] ?? 0),
                    .init(label: "£10", value: 10.0, count: denominationsAny["10.0"] ?? 0),
                    .init(label: "£5",  value: 5.0,  count: denominationsAny["5.0"]  ?? 0),
                    .init(label: "£2",  value: 2.0,  count: denominationsAny["2.0"]  ?? 0),
                    .init(label: "£1",  value: 1.0,  count: denominationsAny["1.0"]  ?? 0),
                    .init(label: "50p", value: 0.5,  count: denominationsAny["0.5"]  ?? 0),
                    .init(label: "20p", value: 0.2,  count: denominationsAny["0.2"]  ?? 0),
                    .init(label: "10p", value: 0.1,  count: denominationsAny["0.1"]  ?? 0),
                    .init(label: "5p",  value: 0.05, count: denominationsAny["0.05"] ?? 0),
                    .init(label: "2p",  value: 0.02, count: denominationsAny["0.02"] ?? 0),
                    .init(label: "1p",  value: 0.01, count: denominationsAny["0.01"] ?? 0),
                ]

                return denominations

            }
        }
        return nil
    }
    

    
}

