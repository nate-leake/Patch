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
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var transactionData: FetchedResults<Transaction>
    
    @State private var activeSheet: ActiveSheet?
    @State var editingTansaction: Transaction?
    
    let formatter: () = DateFormatter().dateStyle = .short
    var numberFormatHandler = NumberFormatHandler()
    
    
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
            
            Spacer()
            
            VStack(spacing: 90){
                ForEach(transactionData){ transaction in
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
                TransactionDetailsView()
                    .environmentObject(dataController)
            case .editing:
                if let t = self.editingTansaction {
                    TransactionDetailsView(transaction: t)
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
        TransactionsView()
            .environment(\.managedObjectContext, dataController.context)
            .environmentObject(dataController)
            .environmentObject(ColorContent())
    }
}
