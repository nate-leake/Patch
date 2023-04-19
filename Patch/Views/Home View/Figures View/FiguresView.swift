//
//  FiguresView.swift
//  Patch
//
//  Created by Nate Leake on 4/4/23.
//

import SwiftUI

struct FiguresView: View {
    @EnvironmentObject var colors:ColorContent
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    FigureContentView(title: "Income", percentage: 56.67, image: "income")
                        .coordinateSpace(name: "Custom")
                    Spacer()
                    FigureContentView(title: "Expenses", percentage: 22.30, image: "expenses")
                        .coordinateSpace(name: "Custom")
                    Spacer()
                    FigureContentView(title: "Savings", percentage: 10.59, image: "savings")
                        .coordinateSpace(name: "Custom")
                }
            }
            .padding()
            .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(gradient: Gradient(colors: [colors.Primary, colors.Tertiary]), startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: 4)
                )
        }
    }
}

struct FiguresView_Previews: PreviewProvider {
    static var previews: some View {
        FiguresView()
            .environmentObject(ColorContent())
    }
}
