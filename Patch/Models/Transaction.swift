//
//  Transaction.swift
//  Patch
//
//  Created by Nate Leake on 7/26/23.
//
//

import Foundation
import SwiftData


@Model public class Transaction {
    var amount: Int64 = Int64(0.0)
    var date: Date?
    public var id: UUID?
    var memo: String?
    var category: Category?
    
    init(amount: Int, date: Date?, memo: String?, category: Category?) {
        self.amount = Int64(amount)
        self.date = date
        self.id = UUID()
        self.memo = memo
        self.category = category
    }
    
    func edit(amount: Int, date: Date, memo: String, category: Category){
        self.amount = Int64(amount)
        self.date = date
        self.memo = memo
        self.category = category
    }
}
