//
//  AllergensModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 09/02/26.
//

import Foundation
import SwiftUI

struct AllergensListModel: Identifiable, Equatable, Sendable, Codable {
    var id = UUID()
    let label: String
    var value: Bool
    var image: String?

    static func defaultValue() -> [AllergensListModel] {

        return [

            .init(label: "Celery", value: false, image: nil),
            .init(
                label: "Cereals containing gluten",
                value: false,
                image: nil
            ),
            .init(label: "Crustaceans", value: false, image: nil),
            .init(label: "Eggs", value: false, image: nil),
            .init(label: "Fish", value: false, image: nil),
            .init(label: "Lupin", value: false, image: nil),
            .init(label: "Milk", value: false, image: nil),
            .init(label: "Mollusc", value: false, image: nil),
            .init(label: "Mustard", value: false, image: nil),
            .init(label: "Nuts", value: false, image: nil),
            .init(label: "Peanuts", value: false, image: nil),
            .init(label: "Sesame seeds", value: false, image: nil),
            .init(label: "Soya", value: false, image: nil),
            .init(label: "Sulphur Dioxide", value: false, image: nil),
        ]

    }
}
