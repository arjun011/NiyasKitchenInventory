//
//  POStatus.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 04/09/25.
//

import Foundation
import SwiftUICore

enum POStatus: String, CaseIterable, Identifiable {
    case all = "All", draft = "DRAFT", sent = "SENT", partial = "PARTIAL", received = "RECEIVED", closed = "CLOSED", canceled = "CANCELED"
    var id: String { rawValue }
    var chipColor: Color {
        switch self {
        case .draft: return .gray
        case .sent: return .brandPrimary
        case .partial: return .orange
        case .received: return .green
        case .closed: return .secondary
        case .canceled: return .red
        case .all: return .secondary
        }
    }
}
