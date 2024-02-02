//
//  Game.swift
//  DiceOff
//
//  Created by Игорь Михайлов on 29.11.2023.
//

import SwiftUI

enum AI: String, CaseIterable {
    case HotSeat, AI
}

class Game: ObservableObject {
    var rows: [[Dice]]
    
    let numRows: Int
    let numCols: Int
    
    @Published var activePlayer = Player.green
    @Published var state = GameState.waiting
    
    @Published var greenScore = 0
    @Published var redScore = 0
    
    @Published var spreadDices = [Dice]()
    
    private var changeList = [Dice]()
    private var spreadChangeList = [Dice]()
    
    var aiPlayer = Player.red
    var ai = AI.HotSeat
    
    var availableOwners: [Player] {
        [.none, aiPlayer]
    }
    
    var checkedDices = [Dice]()
    
    init(rows: Int, cols: Int) {
        numRows = rows
        numCols = cols
        
        self.rows = [[Dice]]()
        
        for rowIndex in 0..<numRows {
            var newRow = [Dice]()
            
            for colIndex in 0..<numCols {
                newRow.append(Dice(row: rowIndex, col: colIndex))
            }
            
            self.rows.append(newRow)
        }
        
        for rowIndex in 0..<numRows {
            for colIndex in 0..<numCols {
                self.rows[rowIndex][colIndex].neighbors = getNeighbors(row: rowIndex, col: colIndex)
            }
        }
    }
    
    private func getNeighbors(row: Int, col: Int) -> Neighbors {
        var result = Neighbors()
        
        if row > 0 {
            result.top = rows[row-1][col]
            result.list.append(result.top!)
        }
        
        if row < numRows-1 {
            result.bottom = rows[row+1][col]
            result.list.append(result.bottom!)
        }
        
        if col > 0 {
            result.left = rows[row][col-1]
            result.list.append(result.left!)
        }
        
        if col < numCols-1 {
            result.right = rows[row][col+1]
            result.list.append(result.right!)
        }
        

        return result
    }
    
    private func bump(_ dice: Dice) {
        dice.value += 1
        dice.owner = activePlayer
        dice.changeAmount = 1
        
        withAnimation {
            dice.changeAmount = 0
        }
        
        if dice.value > dice.neighbors.count {
            dice.value -= dice.neighbors.count
            spreadChangeList.append(dice)
            
            for neighbor in dice.neighbors.list {
                changeList.append(neighbor)
            }
        }
    }
    
    private func updateScores() {
        var newGreenScore = 0
        var newRedScore = 0
        
        for row in rows {
            for dice in row {
                if dice.owner == .green {
                    newGreenScore += dice.value
                } else if dice.owner == .red {
                    newRedScore += dice.value
                }
            }
        }
        
        greenScore = newGreenScore
        redScore = newRedScore
    }
    
    private func runChanges() {
        let toChange = changeList
        changeList.removeAll()
        spreadChangeList.removeAll()
        
        for dice in toChange {
            bump(dice)
        }
        
        spreadDices = spreadChangeList
        
        if !changeList.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.runChanges()
            }
        } else {
            updateScores()
            nextTurn()
        }
    }
    
    private func nextTurn() {
        withAnimation {
            if activePlayer == .green {
                activePlayer = .red
            } else {
                activePlayer = .green
            }
        }
        if ai != .HotSeat && activePlayer == .red {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let dice = self.getMoveDice() {
                    self.privateIncrement(dice)
                } else {
                    print("You won")
                }
            }
        } else {
            state = .waiting
        }
    }
    
    private func isAvailable(_ dice: Dice) -> Bool {
        return availableOwners.contains(where: { $0 == dice.owner })
    }
    
    private func isProfit(_ dice: Dice) -> Bool {
        return dice.neighbors.list.filter { neighbor in
            !isAvailable(neighbor) &&
            (neighbor.power > dice.power)
        }.count == 0
    }
    
    private func isChecked(_ dice: Dice) -> Bool {
        return checkedDices.contains { $0 == dice }
    }
    
    private func getRandomDice() -> Dice? {
        
        for row in rows {
            for dice in row {
                if isAvailable(dice) {
                    return dice
                }
            }
        }
        return nil
    }
    
    private func getBorderEnemyDices() -> [Dice] {
        var result = [Dice]()
        
        for row in rows {
            for dice in row {
                if !isAvailable(dice) && dice.neighbors.list.contains(where: { isAvailable($0) }) {
                    result.append(dice)
                }
            }
        }
        
        return result
    }
    
    private func getMoveDice() -> Dice? {
        let borderEnemyDices = getBorderEnemyDices().sorted(by: { $0.power > $1.power })
        
        for enemyDice in borderEnemyDices {
            let mostProfit = enemyDice.neighbors.list.filter({ isAvailable($0) && isProfit($0) }).max(by: { $0.power < $1.power })
            if (mostProfit != nil) {
                return mostProfit
            }
        }
        
        return getRandomDice()
    }
    
    private func privateIncrement(_ dice: Dice) {
        changeList.append(dice)
        runChanges()
    }
    
    func increment(_ dice: Dice) {
        guard state == .waiting else { return }
        guard dice.owner == .none || dice.owner == activePlayer else { return }
        
        state = .changing
        changeList.append(dice)
        runChanges()
    }
}
