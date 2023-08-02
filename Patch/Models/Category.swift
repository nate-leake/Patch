//
//  Category.swift
//  Patch
//
//  Created by Nate Leake on 7/26/23.
//
//

import Foundation
import SwiftData


@Model public class Category {
    var date: Date?
    public var id: UUID?
    var limit: Int64 = Int64(0.0)
    var symbolName: String?
    var title: String?
    var type: String?
    var used: Int64 = Int64(0.0)
    var account: Account?
    @Relationship(inverse: \Transaction.category) var transactions: [Transaction]?
    
    init(date: Date?, limit: Int, symbolName: String?, title: String?, type: String?, account: Account?) {
        self.date = date
        self.id = UUID()
        self.limit = Int64(limit)
        self.symbolName = symbolName
        self.title = title
        self.type = type
        self.used = 0
        self.account = account
        self.transactions = [Transaction]()
    }
    
    func edit(date: Date, limit: Int, symbolName: String, title: String, type: String, account: Account){
        self.date = date
        self.limit = Int64(limit)
        self.symbolName = symbolName
        self.title = title
        self.type = type
        self.account = account
    }
}
