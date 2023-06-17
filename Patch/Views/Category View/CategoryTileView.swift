//
//  CategoryTileView.swift
//  Patch
//
//  Created by Nate Leake on 4/29/23.
//

import SwiftUI

struct CategoryTileView: View {
    @EnvironmentObject var colors: ColorContent
    
    @ObservedObject var category: Category
    
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
                CategoryProgressView(image: self.category.symbolName ?? "nosign", percentage: Double(self.category.used) / Double(self.category.limit) * 100.0)
                    .frame(width: 65.0)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                Spacer()
                VStack(spacing: 10){
                    HStack{
                        Text(category.title ?? "No title")
                        Text("Limit: \(numberFormatHandler.formatInt(value: Int(category.limit)))")
                            .opacity(0.7)
                    }
                    HStack{
                        Text("\(numberFormatHandler.formatInt(value: Int(category.used )))")
                        Rectangle()
                            .frame(width: 1, height: 17)
                        Text("\(numberFormatHandler.formatInt(value: Int(category.limit - category.used))) Left")
                    }
                    
                } 
                Spacer()
                Spacer()
            }            
        }
    }
}

struct CategoryTileView_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    
    static func getSampleCategory()-> Category{
        let request = Category.fetchRequest()
        let allCategories = try? dataController.context.fetch(request)
        return (allCategories?.first)!
    }
    
    static var previews: some View {
        CategoryTileView(category: getSampleCategory())
            .environmentObject(ColorContent())
    }
}
