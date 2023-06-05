//
//  TransactionsView.swift
//  Patch
//
//  Created by Nate Leake on 4/10/23.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case creating, editing
    
    var id: Int {
        hashValue
    }
}

struct TransactionsView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var dataController: DataController
    
    @ObservedObject var monthViewing: CurrentlyViewedMonth
        
    @State private var activeSheet: ActiveSheet?
    @State var editingTansaction: Transaction?
    
    let formatter: () = DateFormatter().dateStyle = .short
    var numberFormatHandler = NumberFormatHandler()
    
    init(monthViewing: CurrentlyViewedMonth){
        self.monthViewing = monthViewing
    }
    
    var body: some View {
        LazyVStack{
            ZStack{
                HStack(){
                    Spacer()
                    Image(systemName: "plus.app")
                        .padding(.vertical, 2.0)
                        .padding(.horizontal, 12.0)
                        .foregroundColor(colors.Accent)
                        .font(.system(.largeTitle))
                        .onTapGesture {
                            activeSheet = .creating
                        }
                }
                
                HStack{
                    Spacer()
                    Text("Transactions")
                        .font(.system(.title))
                    Spacer()
                }
            }
            MonthSelectorView()
            Spacer()
            
            VStack(spacing: 20){
                ForEach(Array(monthViewing.currentTransactions), id:\.id) { transaction in
                    TransactionTileView(transaction: transaction)
                        .padding(.horizontal)
                    
                        .onTapGesture {
                            print("Going to edit \(String(describing: transaction.memo))")
                            self.editingTansaction = transaction
                            print("Still going to edit \(String(describing: self.editingTansaction?.memo))")
                            self.activeSheet = .editing
                            print("I promise! Still going to edit \(String(describing: self.editingTansaction?.memo))")
                        }
                }
                
            }
            
            Spacer()
        }
        
        .sheet(item: self.$activeSheet) { item in
            switch item {
            case .creating:
                TransactionDetailsView(monthViewing: self.monthViewing)
                    .environmentObject(dataController)
            case .editing:
                if let t = self.editingTansaction {
                    TransactionDetailsView(monthViewing: monthViewing, transaction: t)
                        .environmentObject(dataController)
                } else {
                    VStack{
                        CustomSheetHeaderView(sheetTitle: "Known Bug", submitText: "Close", validateFeilds: {() -> Bool in return true})
                            .padding(.horizontal, 20)
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.yellow)
                            .font(.system(.title))
                            .padding(.bottom, 20)
                        Text("Please close and try again.")
                            .padding(.bottom, 10)
                        Text("You may need to select a different transaction first.")
                            .multilineTextAlignment(.center)
                            .opacity(0.6)
                        Spacer()
                    }
                    
                }
            }
        }
        
    }
    
}

struct TransactionsView_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        TransactionsView(monthViewing: CurrentlyViewedMonth(MOC: dataController.context))
            .environment(\.managedObjectContext, dataController.context)
            .environmentObject(dataController)
            .environmentObject(ColorContent())
    }
}
