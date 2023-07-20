//
//  TemplateCategoryView.swift
//  Patch
//
//  Created by Nate Leake on 7/18/23.
//

import SwiftUI

struct TemplateCategoryView: View {
    @EnvironmentObject var colors: ColorContent
    
    @State var category: TemplateCategory
    
    var cornerRadius: CGFloat = 12
    var numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(colors.Fill)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            category.type == "Expense" ? colors.Primary : colors.Accent,
                            lineWidth: 3
                        )
                )
            
            HStack{
                Spacer()
                Spacer()
                VStack(spacing: 10){
                    VStack(spacing: 10){
                        Text(self.$category.name.wrappedValue )
                        Text("Limit: \(numberFormatHandler.formatInt(value: Int(category.limit)))")
                            .opacity(0.7)
                    }
                    
                }
                Spacer()
                Image(systemName: self.$category.symbol.wrappedValue)
                    .frame(width: 40)
                    .font(.title)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            .padding(.vertical, 15)
        }
    }
}

#Preview {
    TemplateCategoryView(category: TemplateCategory(name: "Food", type: "Expense", limit: 10000, symbol: "nosign"))
        .environmentObject(ColorContent())
}
