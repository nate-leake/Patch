//
//  CurrentlyViewedMonth.swift
//  Patch
//
//  Created by Nate Leake on 6/3/23.
//

import Foundation
import SwiftData

class CurrentlyViewedMonth: ObservableObject {
    @Published var monthStart: Date = Date().startOfMonth()
    @Published var calculations = Calculations()
    
    
    private var dateComponent = DateComponents()
    
    private let typeSort = NSSortDescriptor(key:"type", ascending: false)
    private let alphSort = NSSortDescriptor(key: "title", ascending: true)
    
    init(monthStart: Date = Date().startOfMonth()) {
        self.monthStart = monthStart
        self.dateComponent.month = 1
    }
    
    func viewNextMonth(){
        self.dateComponent.month = 1
        self.monthStart = Calendar.current.date(byAdding: self.dateComponent, to: self.monthStart)!
    }
    
    func viewLastMonth(){
        self.dateComponent.month = -1
        self.monthStart = Calendar.current.date(byAdding: self.dateComponent, to: self.monthStart)!
    }
}
