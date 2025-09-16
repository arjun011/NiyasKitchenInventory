//
//  PunchModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 16/09/25.
//

import Foundation
@preconcurrency import FirebaseFirestore

struct PunchModel: Codable, Identifiable, Hashable, Sendable {
    @DocumentID var id: String?
    var timestamp: Date
    var type: PunchType
    var isAutoOut: Bool?      // optional tag if punch was system generated
    var isIrregular: Bool?    // optional tag for missed punch patterns

    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case type
        case isAutoOut
        case isIrregular
    }
}

enum PunchType: String, Codable, CaseIterable, Sendable {
    case `in`
    case out
}
