//
//  Dice.swift
//  DiceOff
//
//  Created by Игорь Михайлов on 29.11.2023.
//

import Foundation

struct Neighbors {
    var top: Dice? = nil
    var right: Dice? = nil
    var bottom: Dice? = nil
    var left: Dice? = nil
    
    var list = [Dice]()
    
    var count: Int {
        list.count
    }
}

struct ProfitNeighborsInfo {
    var list: [Dice]
    var depth: Int
}

class Dice: Equatable, Identifiable, ObservableObject {
    @Published var value = 1
    @Published var changeAmount = 0.0
    
    var power: Int {
        value + (4-neighbors.count)
    }
    
    var owner = Player.none
    let id = UUID()
    let row: Int
    let col: Int
    var neighbors = Neighbors()
    
    static func == (lhs: Dice, rhs: Dice) -> Bool {
        lhs.id == rhs.id
    }
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}
