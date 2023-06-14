//
//  TransactionsView.swift
//  Patch
//
//  Created by Nate Leake on 4/10/23.
//

import SwiftUI

struct TransactionsView: View {
    @Environment(\.dismiss) var dismissSheet
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var dataController: DataController
    
    @ObservedObject var monthViewing: CurrentlyViewedMonth

    @State var isPresented = false
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
                            self.isPresented = true
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
                            self.editingTansaction = transaction
                        }
                }
                
            }
            
            Spacer()
        }
        
        .sheet(item: self.$editingTansaction) { editTransaction in
            TransactionDetailsView(monthViewing: monthViewing, transaction: editTransaction)
                .environmentObject(dataController)
        }
        
        .sheet(isPresented: self.$isPresented, onDismiss: {self.isPresented = false}){
            TransactionDetailsView(monthViewing: self.monthViewing)
                .environmentObject(dataController)
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
