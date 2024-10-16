//
//  FiguresView.swift
//  Patch
//
//  Created by Nate Leake on 4/4/23.
//

import SwiftUI
import CoreData

struct FiguresView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors:ColorContent
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var monthViewing: CurrentlyViewedMonth
    
    @FetchRequest(sortDescriptors: [
        //        SortDescriptor(\.title),
        SortDescriptor(\.type, order: .reverse)
    ]) var accountsData: FetchedResults<Account>
        
    @ObservedObject var calculations: Calculations
    let NFH = NumberFormatHandler()
    var showFiguresDollars = UserDefaults.standard.bool(forKey: "SHOW_UI_FIGURES_DOLLARS")
    
    init(calculations: Calculations){
        self.calculations = calculations
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    VStack(spacing: 4){
                        FigureContentView(image: "income",
                                          percentage: calculations.percentIncomeGained,
                                          title: "Income")
                        if showFiguresDollars {
                            Text(NFH.formatInt(value: Int(calculations.dollarIncomeGained)))
                                .font(.system(.footnote))
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4){
                        FigureContentView(image: "expenses",
                                          percentage: calculations.percentExpensesPaid,
                                          title: "Expenses")
                        if showFiguresDollars {
                            Text(NFH.formatInt(value: Int(calculations.dollarExpensesPaid)))
                                .font(.system(.footnote))
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4){
                        FigureContentView(image: "savings",
                                          percentage: calculations.percentSavings,
                                          title: "Savings")
                        if showFiguresDollars {
                            Text(NFH.formatInt(value: Int(calculations.dollarSavings)))
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
    static let cvm = CurrentlyViewedMonth(MOC: dataController.context)
    
    static var previews: some View {
        FiguresView(calculations: cvm.calculations)
            .environmentObject(dataController)
            .environmentObject(ColorContent())
            .environment(\.managedObjectContext, dataController.context)
            .environmentObject(cvm)
        
    }
}
