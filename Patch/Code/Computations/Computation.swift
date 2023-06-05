//
//  CategoryComputation.swift
//  Patch
//
//  Created by Nate Leake on 5/1/23.
//

import Foundation
import CoreData


class Calculations: ObservableObject {
    @Published private(set) var percentIncomeGained: Double = 0.0
    @Published private(set) var percentExpensesPaid: Double = 0.0
    @Published private(set) var percentSavings: Double = 0.0
    @Published private(set) var dollarIncomeGained: Int64 = 0
    @Published private(set) var dollarExpensesPaid: Int64 = 0
    @Published private(set) var dollarSavings: Int64 = 0
    
    func performAllCalulations(categories: [Category]?){
        self.calculatePercentIncomeGained(categories: categories)
        self.calculatePercentExpensesPaid(categories: categories)
        self.calculatePercentSaving(categories: categories)
        
        self.calculateDollarIncomeGained(categories: categories)
        self.calculateDollarExpensesPaid(categories: categories)
        self.calculateDollarSavings(categories: categories)
    }
    
    private func calculateDollarIncomeGained(categories: [Category]?){
        var totalIncomeGained: Int64 = 0
                
        if let categoriesArray = categories{
            for category in categoriesArray {
                if category.type == "Income"{
                    totalIncomeGained += category.used
                }
            }
        }
        
        self.dollarIncomeGained = totalIncomeGained
    }
    
    private func calculateDollarExpensesPaid(categories: [Category]?){
        var totalExpensesPaid: Int64 = 0
        
        if let categoriesArray = categories{
            for category in categoriesArray {
                if category.type == "Expense"{
                    totalExpensesPaid += category.used
                }
            }
        }
        
        self.dollarExpensesPaid = totalExpensesPaid
    }
    
    private func calculateDollarSavings(categories: [Category]?){
        var totalIncomeMax: Int64 = 0
        var totalExpensesMax: Int64 = 0
        
        if let categoriesArray = categories{
            for category in categoriesArray {
                if category.type == "Expense"{
                    if category.used > category.limit{
                        totalExpensesMax += category.used
                    } else {
                        totalExpensesMax += category.limit
                    }
                } else if category.type == "Income"{
                    if category.used > category.limit{
                        totalIncomeMax += category.used
                    } else {
                        totalIncomeMax += category.limit
                    }
                }
            }
        }
        
        self.dollarSavings = totalIncomeMax - totalExpensesMax
    }
    
    private func calculatePercentIncomeGained(categories: [Category]?){
        var totalIncomeMax: Int = 0
        var totalIncomeGained: Int = 0
        
        if let categoriesArray = categories{
            for category in categoriesArray {
                if category.type == "Income"{
                    totalIncomeMax += Int(category.limit)
                    totalIncomeGained += Int(category.used)
                }
            }
        }
        
        self.percentIncomeGained = floor(round( (Double(totalIncomeGained) / Double(totalIncomeMax)) * 1000))/10.0
    }
    
    private func calculatePercentExpensesPaid(categories: [Category]?){
        var totalExpensesMax: Int = 0
        var totalExpensesPaid: Int = 0
        
        if let categoriesArray = categories{
            for category in categoriesArray {
                if category.type == "Expense"{
                    totalExpensesMax += Int(category.limit)
                    totalExpensesPaid += Int(category.used)
                }
            }
        }
        
        self.percentExpensesPaid = floor(round( (Double(totalExpensesPaid) / Double(totalExpensesMax)) * 1000))/10.0
        
    }
    
    
    private func calculatePercentSaving(categories: [Category]?){
        var totalIncomeMax: Int = 0
        var totalExpensesMax: Int = 0
                
        if let categoriesArray = categories{
            for category in categoriesArray {
                if category.type == "Expense"{
                    if category.used > category.limit{
                        totalExpensesMax += Int(category.used)
                    } else {
                        totalExpensesMax += Int(category.limit)
                    }
                } else if category.type == "Income"{
                    if category.used > category.limit{
                        totalIncomeMax += Int(category.used)
                    } else {
                        totalIncomeMax += Int(category.limit)
                    }
                }
            }
        }
        
        self.percentSavings = floor(round( (Double(totalIncomeMax-totalExpensesMax) / Double(totalIncomeMax)) * 1000))/10.0
    }
}


class Computation {
    let checking : Checking
    
    init(context: NSManagedObjectContext) {
        self.checking = Checking(context: context)
    }
    
    
}

class Checking {
    let context: NSManagedObjectContext
    var monthViewing: CurrentlyViewedMonth?
    let calculations = Calculations()
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    func getPercentUsed(category: Category) -> Double{
        return Double(category.used/category.limit)
    }
    
    func addTransaction(category: Category, transaction: Transaction){
        print(category.account?.name ?? "No category account")
        category.used += transaction.amount
    }
    
    func deleteTransaction(category: Category, transaction: Transaction){
        category.used -= transaction.amount
    }
    
    func editTransaction(oldCategory: Category, newCategory: Category, oldAmount: Int64, newAmount: Int64){
        if oldCategory != newCategory{
            oldCategory.used -= oldAmount
            newCategory.used += newAmount
        }
        
        else if oldAmount == newAmount{
            print("No changes to category used")
        } else if oldAmount > newAmount{ // the transaction amount is being lowered
            newCategory.used -= oldAmount-newAmount
            print("Category used increased by \(oldAmount-newAmount)")
        } else { // the transaction amount is being increased
            newCategory.used += newAmount-oldAmount
            print("Category used decreased by \(newAmount-oldAmount)")
        }
    }
}
