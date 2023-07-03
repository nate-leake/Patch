//
//  StaringBalanceSheetView.swift
//  Patch
//
//  Created by Nate Leake on 6/30/23.
//

import SwiftUI

struct StartingBalanceSheetView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var monthViewing: CurrentlyViewedMonth
    @EnvironmentObject var startingBalancesStore: StartingBalanceStore
    
    @FocusState private var isFocused: Bool
    
    @State private var amount: Int = 0
    @State var isShowingAmountValidation: Bool = false
    
    let dateFormatter = DateFormatter()
    
    let saveAction: ()->Void
    
    init(saveAction: @escaping ()->Void) {
        self.saveAction = saveAction
        self.dateFormatter.dateFormat = "MMMM"
        self.dateFormatter.locale = Locale.current
    }
    
    func validateFeilds() -> Bool{
        startingBalancesStore.balances.append(MonthStartingBalance(month: monthViewing.monthStart, startingBalance: amount))
        saveAction()
        return true
    }
    
    var body: some View {
        ZStack{
            colors.Fill
                .ignoresSafeArea()
            VStack(spacing: 20){
                CustomSheetHeaderView(sheetTitle: "Hello, \(dateFormatter.string(from: monthViewing.monthStart))!", submitText: "Save", validateFeilds: validateFeilds)
                    .foregroundColor(colors.Accent)
                    .font(.system(.title))
                    .padding(.horizontal, 20)
                Text("It's time to enter this month's starting balance")
                
                CurrencyField(value: $amount)
                    .padding(.horizontal, 20)
                    .foregroundColor(colors.InputText)
                    .font(.system(.title2))
                    .focused($isFocused)
                
//                Text("You can change this amount later in settings")
//                    .font(.system(.footnote))
//                    .opacity(0.5)
                
                Spacer()
            }
        }
    }
}

struct StaringBalanceSheetView_Previews: PreviewProvider {
    static var dataController: DataController = DataController()
    static var startingBalancesStore = StartingBalanceStore()
    
    static var previews: some View {
        StartingBalanceSheetView()
        {
            Task {
                do {
                    try await startingBalancesStore.save(balances: startingBalancesStore.balances)
                }
                catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
        .task {
            do {
                try await startingBalancesStore.load()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        .environment(\.managedObjectContext, dataController.context)
        .environmentObject(dataController)
        .environmentObject(ColorContent())
        .environmentObject(CurrentlyViewedMonth(MOC: dataController.context))
    }
}
