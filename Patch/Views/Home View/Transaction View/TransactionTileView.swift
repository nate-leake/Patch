//
//  TransactionTileView.swift
//  Patch
//
//  Created by Nate Leake on 4/29/23.
//

import SwiftUI

struct TransactionTileView: View {
    @EnvironmentObject var colors: ColorContent
    let numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    let dateFormatter = DateFormatter()
    var transaction: Transaction
    
    var cornerRadius: CGFloat = 16
    
    init(transaction: Transaction) {
        self.transaction = transaction
        self.dateFormatter.dateFormat = "MM/dd/YYYY"
        self.dateFormatter.locale = Locale.current
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(colors.Fill)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            transaction.category!.type == "Expense" ? colors.Primary : colors.Accent,
                            lineWidth: 4
                        )
                )
            VStack{
                HStack{
                    Text("\(transaction.memo ?? "N/A")")
                        .opacity(transaction.memo == nil ? 0.5 : 1.0)
                    Text("\(numberFormatHandler.formatInt(value: Int(transaction.amount)))")
                        .opacity(0.7)
                }
                HStack{
                    Text("\(dateFormatter.string(from: transaction.date!))")
                    Rectangle()
                        .frame(width: 1, height: 17)
                    Text(transaction.category?.title ?? "Unkown Category")
                    
                }
            }
            .padding(.vertical, 20)
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
