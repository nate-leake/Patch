//
//  Account.swift
//  Patch
//
//  Created by Nate Leake on 7/26/23.
//
//

import Foundation
import SwiftData


@Model public class Account {
    public var id: UUID?
    var name: String?
    var percentExpenses: Double? = 0
    var percentIncome: Double? = 0.0
    var percentSaving: Double? = 0.0
    var type: String?
    @Relationship(inverse: \Category.account) var categories: [Category]?
    
    init(name: String?, type: String?) {
        self.id = UUID()
        self.name = name
        self.percentExpenses = 0
        self.percentIncome = 0
        self.percentSaving = 0
        self.type = type
        self.categories = categories
    }
    
    func edit(name: String, type: String){
        self.name = name
        self.type = type
    }
    
}
