//
//  MovementType.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 30/08/25.
//

import Foundation
import SwiftUICore

enum MovementType: String, CaseIterable, Identifiable {
    var id: String {
        rawValue
    }

    var icon: String {
        switch self {
        case .in: return "arrow.down.circle.fill"
        case .out: return "arrow.up.circle.fill"
        case .waste: return "trash.circle.fill"
        }
    }
    var tint: Color {
        switch self {
        case .in: return .brandPrimary
        case .out: return .appWarning
        case .waste: return .appDanger
        }
    }
    
    var sign: String {
        switch self {
        case .in: return "+"
        default:
            return "-"
        }
    }

    case `in` = "IN"
    case out = "OUT"
    case waste = "WASTE"
}
