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
    let computations = Computation()
    
    var isPreviewing: Bool = false
    
    init(isPreviewing: Bool = false) {
        container.loadPersistentStores{desc, error in
            if let error = error {
                print("Failed to load DataContoller data: \(error.localizedDescription)")
            }
        }
        
        self.context = self.container.viewContext
        
        if isPreviewing {
            self.isPreviewing = true
            self.populatSampleData()
        }
        
        self.accountIntegrityChecker()
        self.categoryIntegrityChecker()
    }
    
    func save(){
        do {
            try self.context.save()
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
        account.calculateAllVaules()
        
        if !isPreviewing{save()}
    }
    
    func editCategory(category: Category, name: String, limit: Int, type: String, symbolName: String){
        category.title = name
        category.limit = Int64(limit)
        category.type = type
        category.symbolName = symbolName
                
        category.account?.calculateAllVaules()
        
        if !isPreviewing{save()}
    }
    
    func addTransaction(category: Category, date: Date, amount: Int, memo: String){
        let newTransaction = Transaction(context: self.context)
        newTransaction.id = UUID()
        newTransaction.date = date
        newTransaction.amount = Int64(amount)
        newTransaction.memo = memo
        
        computations.checking.addTransaction(category: category, transaction: newTransaction)
        
        category.addToTransactions(newTransaction)
        if !isPreviewing{save()}
    }
    
    func editTransaction(transaction: Transaction, category: Category, date: Date, amount: Int, memo: String){
        let oldAmount: Int64 = transaction.amount
        let oldCategory: Category = transaction.category!
        
        transaction.date = date
        transaction.amount = Int64(amount)
        transaction.memo = memo
                
        if oldCategory != category {
            oldCategory.removeFromTransactions(transaction)
            category.addToTransactions(transaction)
        }
        
        computations.checking.editTransaction(oldCategory: oldCategory, newCategory: category, oldAmount: oldAmount, newAmount: transaction.amount)
        
        if !isPreviewing{save()}
    }
    
    func accountIntegrityChecker(){
        let request = Account.fetchRequest()
        let allAccounts = try? self.context.fetch(request)
        
        if allAccounts?.count == 0 {
            print("No accounts found. Adding the default checking account.")
            addAccount(name: "Checking Default", type: "Checking")
        }
        
        for account in allAccounts!{
            account.calculateAllVaules()
//            print(account.id ??  "No account ID", ":", account.name ?? "Unassigned account", ":", account.type ?? "Unassigned type")
        }
        
    }
    
    func categoryIntegrityChecker(){
        let request = Category.fetchRequest()
        let allCategories = try? self.context.fetch(request)
        
        var hasType = true
        var hasAccount = true
        
        for category in allCategories!{
            
            guard category.id != nil else {
                category.id = UUID()
                return
            }
            
            guard category.symbolName != nil else {
                category.symbolName = "nosign"
                if !isPreviewing{save()}
                return
            }
            
            guard category.title != nil else {
                category.title = "Unknown Name"
                if !isPreviewing{save()}
                return
            }
            
            guard category.type != nil else {
                hasType = false
                return
            }
            
            
            guard category.account != nil else {
                hasAccount = false
                return
            }
            
            guard category.date != nil else {
                category.date = Date().startOfMonth()
                return
            }
            
            if !(hasType && hasAccount){
                print("Warning: Category has no type or account: ",
                    category.id ?? "No category ID",
                    "|",
                    category.limit,
                    "|",
                    category.symbolName ?? "No Symbol",
                    "|",
                    category.title ?? "No category title",
                    "|",
                    category.type ?? "Unassigned type",
                    "|",
                    category.used,
                    "|",
                    category.account?.name ?? "Unassigned account"
                )
            }
            
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
            
            self.addCategory(account: allAccounts![0], name: "Paycheck", limit: 100000, type: "Income", symbolName: "dollarsign")
            self.addCategory(account: allAccounts![0], name: "Food", limit: 12000, type: "Expense", symbolName: "fork.knife")
            
            let allCategories = try? self.context.fetch(categoryRequest)
            
            self.addTransaction(category: allCategories![0], date: Date.now, amount: 1293, memo: "Trying this out!")
            self.addTransaction(category: allCategories![1], date: Date.now, amount: 32930, memo: "Payday!")
            self.addTransaction(category: allCategories![0], date: Date.now, amount: 2985, memo: "Trying this out!")
            self.addTransaction(category: allCategories![0], date: Date.now, amount: 0039, memo: "Trying this out!")
            self.addTransaction(category: allCategories![0], date: Date.now, amount: 3925, memo: "Trying this out!")
            self.addTransaction(category: allCategories![0], date: Date.now, amount: 0198, memo: "Trying this out!")
            
        }
    }
    
}
