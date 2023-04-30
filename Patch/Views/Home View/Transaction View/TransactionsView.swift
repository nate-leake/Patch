//
//  TransactionsView.swift
//  Patch
//
//  Created by Nate Leake on 4/10/23.
//

import SwiftUI

struct TransactionsView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var colors: ColorContent
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var transactionData: FetchedResults<Transaction>
    
    @State var showTransactionSheet: Bool = false
    
    var numberFormatHandler = NumberFormatHandler()
    
    let formatter = DateFormatter()
    
    init() {
        self.formatter.dateStyle = .short
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
                            
                            showTransactionSheet.toggle()
                        }
                    
                }
                .sheet(isPresented: $showTransactionSheet, content: {
                    TransactionDetailsView()
                        .environmentObject(dataController)
                    
                })
                
                HStack{
                    Spacer()
                    Text("Transactions")
                        .font(.system(.title))
                    Spacer()
                }
            }
            
            Spacer()
            
            VStack(spacing: 0){
                ForEach(transactionData){ transaction in
                    
                    TransactionTileView(transaction: transaction)
                        .padding()
                }
            }
            
            
            
            Spacer()
        }
        
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    static var previews: some View {
        TransactionsView()
            .environmentObject(dataController)
            .environmentObject(ColorContent())
            .environment(\.managedObjectContext, dataController.context)
    }
}
