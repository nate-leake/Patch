//
//  FiguresView.swift
//  Patch
//
//  Created by Nate Leake on 4/4/23.
//

import SwiftUI
import CoreData

struct FiguresView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var colors:ColorContent
        
    let computations: Computation = Computation()
    
    @FetchRequest(sortDescriptors: [
        //        SortDescriptor(\.title),
        SortDescriptor(\.type, order: .reverse)
    ]) var categoryData: FetchedResults<Category>
    
    @FetchRequest(sortDescriptors: [
        //        SortDescriptor(\.title),
        SortDescriptor(\.type, order: .reverse)
    ]) var accountsData: FetchedResults<Account>
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    
                    FigureContentView(title: "Income",
                                      percentage: accountsData[0].percentIncome,
                                      image: "income")
                        .coordinateSpace(name: "Custom")
                    Spacer()
                    FigureContentView(title: "Expenses",
                                      percentage: accountsData[0].percentExpenses,
                                      image: "expenses")
                        .coordinateSpace(name: "Custom")
                    Spacer()
                    FigureContentView(title: "Savings",
                                      percentage: accountsData[0].percentSaving,
                                      image: "savings")
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
    static let dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        FiguresView()
            .environmentObject(dataController)
            .environmentObject(ColorContent())
            .environment(\.managedObjectContext, dataController.context)
        
    }
}
