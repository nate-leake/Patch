//
//  CurrentlyViewedMonth.swift
//  Patch
//
//  Created by Nate Leake on 6/3/23.
//

import Foundation
import CoreData

class CurrentlyViewedMonth: ObservableObject {
    @Published var monthStart: Date = Date().startOfMonth()
    @Published var currentCategories: [Category]?
    @Published var currentTransactions: [Transaction] = []
    @Published var calculations = Calculations()
    
    private var MOC: NSManagedObjectContext
    
    private var dateComponent = DateComponents()
    private let categoryRequest = Category.fetchRequest()
    
    private let typeSort = NSSortDescriptor(key:"type", ascending: false)
    private let alphSort = NSSortDescriptor(key: "title", ascending: true)
    
    init(MOC: NSManagedObjectContext, monthStart: Date = Date().startOfMonth()) {
        self.monthStart = monthStart
        self.dateComponent.month = 1
        self.MOC = MOC
        
        self.performFetchRequest()
    }
    
    func performFetchRequest(){
        print("Fetching the request \(Date())")
        self.currentTransactions = []
        self.categoryRequest.predicate = NSPredicate(format:  "date == %@", monthStart as CVarArg)
        self.categoryRequest.sortDescriptors = [typeSort, alphSort]
        self.currentCategories = try? MOC.fetch(categoryRequest)
//        print(currentCategories?.count ?? "No current categories")
        
        if let categories = self.currentCategories{
            for c in categories{
                if c.title != nil{ // fire fault
                    if let transactions: Set<Transaction> = c.transactions as? Set<Transaction>{
                        for t in transactions{
                            if t.memo != nil { // fire fault
                                self.currentTransactions.append(t)
                            }
                            
                        }
                    }
                }
            }
            self.currentCategories = categories
        } else {
            print("No categories for this month")
        }
        
        self.currentTransactions = self.currentTransactions.sorted { $0.date ?? Date().endOfMonth() > $1.date ?? Date().endOfMonth() }
        
        self.calculations.performAllCalulations(categories: self.currentCategories)
    }
    
    func viewNextMonth(){
        self.dateComponent.month = 1
        self.monthStart = Calendar.current.date(byAdding: self.dateComponent, to: self.monthStart)!
        
        self.performFetchRequest()
    }
    
    func viewLastMonth(){
        self.dateComponent.month = -1
        self.monthStart = Calendar.current.date(byAdding: self.dateComponent, to: self.monthStart)!
        
        self.performFetchRequest()
    }
}
