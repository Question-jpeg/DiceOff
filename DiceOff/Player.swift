//
//  Player.swift
//  DiceOff
//
//  Created by Игорь Михайлов on 29.11.2023.
//

import SwiftUI

enum Player: String, CaseIterable {
    case none, green, red, orange, purple
    
    var color: Color {
        switch self {
        case .none:
            Color(white: 0.6)
        case .green:
            .green
        case .red:
            .red
        case .orange:
            .orange
        case .purple:
            .purple
        }
    }
}
