//
//  CategoryComputation.swift
//  Patch
//
//  Created by Nate Leake on 5/1/23.
//

import Foundation
import CoreData


extension Account {
    func calculatePercentIncomeGained(){
        var totalIncomeMax: Int = 0
        var totalIncomeGained: Int = 0
        var gainedPercent: Double = 0.0
        
        let categoriesArray: [Category] = self.categories?.allObjects as! [Category]
        
        for category in categoriesArray {
            if category.type == "Income"{
                totalIncomeMax += Int(category.limit)
                totalIncomeGained += Int(category.used)
            }
        }
        
        gainedPercent = floor(round( (Double(totalIncomeGained) / Double(totalIncomeMax)) * 1000))/10.0
        self.percentIncome = gainedPercent
    }
    
    func calculatePercentExpensesPaid(){
        var totalExpensesMax: Int = 0
        var totalExpensesPaid: Int = 0
        var paidPercent: Double = 0.0
        
        let categoriesArray: [Category] = self.categories?.allObjects as! [Category]
        
        for category in categoriesArray {
            if category.type == "Expense"{
                totalExpensesMax += Int(category.limit)
                totalExpensesPaid += Int(category.used)
            }
        }
        
        paidPercent = floor(round( (Double(totalExpensesPaid) / Double(totalExpensesMax)) * 1000))/10.0
        self.percentExpenses = paidPercent
        
    }
    
    
    func calculatePercentSaving(){
        var totalIncomeMax: Int = 0
        var totalExpensesMax: Int = 0
        
        var percentSaving: Double = 0.0
        
        let categoriesArray: [Category] = self.categories?.allObjects as! [Category]
        
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
        
        percentSaving = floor(round( (Double(totalIncomeMax-totalExpensesMax) / Double(totalIncomeMax)) * 1000))/10.0
        self.percentSaving = percentSaving
    }
    
    func calculateAllVaules(){
        self.calculatePercentExpensesPaid()
        self.calculatePercentIncomeGained()
        self.calculatePercentSaving()
    }
}


class Computation{
    let checking = Checking()
    
}

class Checking {
    func getPercentUsed(category: Category) -> Double{
        return Double(category.used/category.limit)
    }
    
    func addTransaction(category: Category, transaction: Transaction){
        print(category.account?.name ?? "No category account")
        category.used += transaction.amount
        category.account?.calculateAllVaules()
    }
    
    func deleteTransaction(category: Category, transaction: Transaction){
        category.used -= transaction.amount
        category.account?.calculateAllVaules()
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
        
        
        
        newCategory.account?.calculateAllVaules()
    }
}
