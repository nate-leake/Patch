//
//  TransactionTileView.swift
//  Patch
//
//  Created by Nate Leake on 4/29/23.
//

import SwiftUI

struct TransactionTileView: View {
    @EnvironmentObject var colors: ColorContent
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let monthDateFormatter = DateFormatter()
    let dayDateFormatter = DateFormatter()
    let numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    
    var cornerRadius: CGFloat = 12
    var transaction: Transaction
    
    
    init(transaction: Transaction) {
        self.transaction = transaction
        self.monthDateFormatter.dateFormat = "MMM"
        self.dayDateFormatter.dateFormat = "d"
        self.monthDateFormatter.locale = Locale.current
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.05))
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            transaction.category?.type == "Expense" ? colors.Primary : colors.Accent,
                            lineWidth: 3
                        )
                )
            
            
            
            LazyVGrid(columns: columns, spacing: 20){
                VStack{
                    Text("\(monthDateFormatter.string(from: transaction.date!))")
                        .font(.system(.footnote))
                        .opacity(0.7)
                        .padding(.bottom, 1)
                    Text("\(dayDateFormatter.string(from: transaction.date!))")
                }
                
                
                
                VStack{
                    Text("\(transaction.memo ?? "N/A")")
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .opacity(transaction.memo == nil ? 0.5 : 1.0)
                        .padding(.bottom, 1)
                    Text("\(numberFormatHandler.formatInt(value: Int(transaction.amount)))")
                        .opacity(0.7)
                        .font(.system(.footnote))
                }
                
                
                VStack{
                    Text(transaction.category?.title ?? "Unkown Category" )
                        .font(.system(.footnote))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 2)
                    Image(systemName: transaction.category?.symbolName ?? "nosign")
                        .font(.system(.body))
                }
                
            }
            .padding(.vertical, 15)
            
            
        }
    }
}

struct TransactionTileView_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    
    static func getSampleTransaction()-> Transaction{
        let request = Transaction.fetchRequest()
        let allTransactions = try? dataController.context.fetch(request)
        return (allTransactions?.first)!
    }
    
    static var previews: some View {
        TransactionTileView(transaction: getSampleTransaction())
            .environmentObject(ColorContent())
    }
}
