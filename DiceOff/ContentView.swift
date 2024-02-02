//
//  ContentView.swift
//  DiceOff
//
//  Created by Игорь Михайлов on 29.11.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var game = Game(rows: 7, cols: 7)
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Text(game.greenScore.formatted())
                    .font(game.activePlayer == .green ? .title.bold() : .title)
                    .padding(10)
                    .background(game.activePlayer == .green ? .green : .green.opacity(0.5))
                    .clipShape(Circle())
                
                Text(game.redScore.formatted())
                    .font(game.activePlayer == .red ? .title.bold() : .title)
                    .padding(10)
                    .background(game.activePlayer == .red ? .red : .red.opacity(0.5))
                    .clipShape(Circle())
             
                Picker("GamePlay", selection: $game.ai) {
                    ForEach(AI.allCases, id: \.self) { ai in
                        Text(ai.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 200)
            }
            
            VStack(spacing: 5) {
                ForEach(game.rows.indices, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(game.rows[row]) { dice in
                            DiceView(dice: dice)
                                .onTapGesture {
                                    game.increment(dice)
                                }
                        }
                    }
                }
            }
            .overlay(
                GeometryReader { geo in
                    let spacersWidth = CGFloat(5*(game.numCols-1))
                    let colsCount = CGFloat(game.numCols)
                    let size = (geo.size.width - spacersWidth) / colsCount                    
                
                    ForEach(game.spreadDices) { dice in
                        let offsetX = (size+5)*CGFloat(dice.col)
                        let offsetY = (size+5)*CGFloat(dice.row)
                        
                        DiceSpreadingView(dice: dice, size: size)
                            .offset(x: offsetX, y: offsetY)
                    }
                }
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
