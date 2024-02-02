//
//  DiceSpreadingView.swift
//  DiceOff
//
//  Created by Игорь Михайлов on 30.11.2023.
//

import SwiftUI

struct DiceSpreadingView: View {
    @State private var animationAmount = 0.0
    
    var dice: Dice
    var size: CGFloat
    
    var diceImage: some View {
        Image(systemName: "die.face.1.fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .background(Rectangle().inset(by: size/10).fill(.black))
    }
    
    var body: some View {
        diceImage
            .foregroundStyle(dice.owner.color)
            .frame(width: size, height: size)
            .overlay(
                GeometryReader { geo in
                    ZStack {
                            if dice.neighbors.left != nil {
                                diceImage
                                    .foregroundStyle(dice.owner.color)
                                    .overlay(
                                        diceImage
                                            .foregroundStyle(.white)
                                            .opacity(1 - animationAmount)
                                    )
                                    .offset(x: -(geo.size.width+5)*animationAmount, y: 0)
                                
                            }
                            if dice.neighbors.right != nil {
                                diceImage
                                    .foregroundStyle(dice.owner.color)
                                    .overlay(
                                        diceImage
                                            .foregroundStyle(.white)
                                            .opacity(1 - animationAmount)
                                    )
                                    .offset(x: (geo.size.width+5)*animationAmount, y: 0)
                            }
                            if dice.neighbors.bottom != nil {
                                diceImage
                                    .foregroundStyle(dice.owner.color)
                                    .overlay(
                                        diceImage
                                            .foregroundStyle(.white)
                                            .opacity(1 - animationAmount)
                                    )
                                    .offset(x: 0, y: (geo.size.height+5)*animationAmount)
                            }
                            if dice.neighbors.top != nil {
                                diceImage
                                    .foregroundStyle(dice.owner.color)
                                    .overlay(
                                        diceImage
                                            .foregroundStyle(.white)
                                            .opacity(1 - animationAmount)
                                    )
                                    .offset(x: 0, y: -(geo.size.height+5)*animationAmount)
                            }
                        }
                }
            )
            .overlay(
                diceImage
                    .foregroundStyle(.white)
                    .opacity(1 - animationAmount)
            )
            .onAppear {
                withAnimation(.default.repeatForever(autoreverses: false)) {
                    animationAmount = 1
                }
            }
    }
}


#Preview {
    let dice = Dice(row: 1, col: 1)
    dice.neighbors.left = Dice(row: 2, col: 2)
    return DiceSpreadingView(dice: dice, size: 50)
}
