//
//  DataController.swift
//  Patch
//
//  Created by Nate Leake on 4/22/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CategoryData")
    let context: NSManagedObjectContext
    
    var isPreviewing: Bool = false
    
    init(isPreviewing: Bool = false) {
        container.loadPersistentStores{desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
        print(container.name)
        self.context = self.container.viewContext
        self.accountIntegrityChecker()
        self.categoryIntegrityChecker()
        
        if isPreviewing {
            self.isPreviewing = true
            self.populatSampleData()
        }
    }
    
    func save(){
        do {
            try self.context.save()
            print("Data saved!")
        } catch {
            print("Could not save data. ")
        }
    }
    
    func addAccount(name: String, type: String){
        let account = Account(context: self.context)
        account.id = UUID()
        account.name = name
        account.type = type
                
        if !isPreviewing{save()}
    }
    
    
    func addCategory(account: Account, name: String, limit: Int, type: String, symbolName: String){
        let category = Category(context: self.context)
        category.id = UUID()
        category.limit = Int64(limit)
        category.title = name
        category.type = type
        category.used = 0
        category.symbolName = symbolName
        
        account.addToCategories(category)
        
        if !isPreviewing{save()}
    }
    
    func editCategory(category: Category, name: String, limit: Int, type: String, symbolName: String){
        category.title = name
        category.limit = Int64(limit)
        category.symbolName = symbolName
        if !isPreviewing{save()}
    }
    
    func addTransaction(category: Category, date: Date, amount: Int, memo: String){
        let newTransaction = Transaction(context: self.context)
        newTransaction.id = UUID()
        newTransaction.date = date
        newTransaction.amount = Int64(amount)
        newTransaction.memo = memo
        
        category.addToTransactions(newTransaction)
        if !isPreviewing{save()}
    }
    
    func editTransaction(transaction: Transaction, category: Category, date: Date, amount: Int, memo: String){
        transaction.date = date
        transaction.amount = Int64(amount)
        transaction.memo = memo
        if !isPreviewing{save()}
    }
    
    func accountIntegrityChecker(){
        let request = Account.fetchRequest()
        let allAccounts = try? self.context.fetch(request)
        for account in allAccounts!{
            print(account.name ?? "Unassigned account", ":", account.type ?? "Unassigned type")
        }
        
    }
    
    func categoryIntegrityChecker(){
        let request = Category.fetchRequest()
        let allCategories = try? self.context.fetch(request)
        for category in allCategories!{
            print(category.title!, ":", category.type ?? "Unassigned type", ",", category.account?.name ?? "Unassigned account")
        }
    }

    
    
    func populatSampleData(){
        let accountRequest = Account.fetchRequest()
        let categoryRequest = Category.fetchRequest()
        var allAccounts = try? self.context.fetch(accountRequest)
        
        if ((allAccounts?.isEmpty) != nil){
            print("Populating sample data")
            
            self.addAccount(name: "Checking", type: "Checking")
            self.addAccount(name: "Savings", type: "Savings")
            
            allAccounts = try? self.context.fetch(accountRequest)
            
            print(allAccounts?.count ?? "0")
            
            self.addCategory(account: allAccounts![0], name: "Paycheck", limit: 100000, type: "Income", symbolName: "dollarsign")
            self.addCategory(account: allAccounts![0], name: "Food", limit: 12000, type: "Expense", symbolName: "fork.knife")
            
            let allCategories = try? self.context.fetch(categoryRequest)
            
            self.addTransaction(category: allCategories![0], date: Date.now, amount: 1293, memo: "Trying this out!")
            self.addTransaction(category: allCategories![1], date: Date.now, amount: 32930, memo: "Payday!")
            
            print(Date.now)
            
        }
    }

}
