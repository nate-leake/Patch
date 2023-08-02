//
//  TransactionsView.swift
//  Patch
//
//  Created by Nate Leake on 4/10/23.
//

import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Environment(\.dismiss) var dismissSheet
    @EnvironmentObject var colors: ColorContent
    
    @ObservedObject var monthViewing: CurrentlyViewedMonth
    @Query private var transactions: [Transaction]

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
                ForEach(transactions, id:\.id) { transaction in
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
        }
        
        .sheet(isPresented: self.$isPresented, onDismiss: {self.isPresented = false}){
            TransactionDetailsView(monthViewing: self.monthViewing)
        }
        
    }
    
}

struct TransactionsView_Previews: PreviewProvider {
    
    static var previews: some View {
        TransactionsView(monthViewing: CurrentlyViewedMonth())
            .environmentObject(ColorContent())
    }
}
