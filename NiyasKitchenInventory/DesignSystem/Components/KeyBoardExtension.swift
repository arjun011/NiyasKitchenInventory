//
//  KeyBoardExtension.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 25/08/25.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    
    func hideKeyboard() {
        UIApplication
            .shared
            .sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil)

    }
}
