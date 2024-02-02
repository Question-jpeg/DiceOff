//
//  DiceView.swift
//  DiceOff
//
//  Created by Игорь Михайлов on 29.11.2023.
//

import SwiftUI

struct DiceView: View {
    
    @ObservedObject var dice: Dice
    
    var body: some View {
        diceImage
            .foregroundStyle(dice.owner.color)
            .overlay(
                diceImage
                    .foregroundStyle(.white)
                    .opacity(dice.changeAmount)
            )
    }
    
    var diceImage: some View {
        Image(systemName: "die.face.\(dice.value).fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    let dice = Dice(row: 1, col: 1)
    dice.owner = .green
    return DiceView(dice: dice)
}
