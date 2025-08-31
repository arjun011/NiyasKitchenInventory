//
//  RangeEnum.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 31/08/25.
//

import Foundation

enum RangeFilter: String, CaseIterable, Identifiable, Hashable {
    case today = "Today", d7 = "7 Days", d30 = "30 Days", all = "All Time"
    var id: String { rawValue }
}
