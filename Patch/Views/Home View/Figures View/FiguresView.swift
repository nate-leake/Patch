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
    @EnvironmentObject var colors:ColorContent
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(sortDescriptors: [
        //        SortDescriptor(\.title),
        SortDescriptor(\.type, order: .reverse)
    ]) var accountsData: FetchedResults<Account>
    
    @FetchRequest(sortDescriptors: [
        //        SortDescriptor(\.title),
        SortDescriptor(\.type, order: .reverse)
    ]) var categoryData: FetchedResults<Category>
    
    let computations: Computation = Computation()
    let NFH = NumberFormatHandler()
    var showFiguresDollars = UserDefaults.standard.bool(forKey: "SHOW_UI_FIGURES_DOLLARS")
    
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    VStack(spacing: 4){
                        FigureContentView(image: "income",
                                          percentage: accountsData[0].percentIncome,
                                          title: "Income")
                        if showFiguresDollars {
                            Text(NFH.formatInt(value: Int(accountsData[0].dollarIncome)))
                                .font(.system(.footnote))
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4){
                        FigureContentView(image: "expenses",
                                          percentage: accountsData[0].percentExpenses,
                                          title: "Expenses")
                        if showFiguresDollars {
                            Text(NFH.formatInt(value: Int(accountsData[0].dollarExpenses)))
                                .font(.system(.footnote))
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4){
                        FigureContentView(image: "savings",
                                          percentage: accountsData[0].percentSaving,
                                          title: "Savings")
                        if showFiguresDollars {
                            Text(NFH.formatInt(value: Int(accountsData[0].dollarSavings)))
                                .font(.system(.footnote))
                        }
                    }
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
