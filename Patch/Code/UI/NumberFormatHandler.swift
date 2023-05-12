//
//  NumberFormatHandler.swift
//  Patch
//
//  Created by Nate Leake on 4/22/23.
//

import Foundation

class NumberFormatHandler{
    var formatter: NumberFormatter = NumberFormatter()
    
    init() {
        self.formatter.numberStyle = .currency
        self.formatter.minimumFractionDigits = 2
        self.formatter.maximumFractionDigits = 2
        self.formatter.locale = .current
    }
    
    func intToNSDecimalNumber(value: Int) -> NSDecimalNumber{
        return NSDecimalNumber(value: Double(value)/100.0)
    }
    
    func nsDecimalNumbertoInt(value: NSDecimalNumber) -> Int{
        Int(truncating: Double(exactly: value)!*100 as NSNumber)
    }
    
    func formatInt(value: Int) -> String {
        return self.formatter.string(from: Double(exactly: value)!/100 as NSNumber)!
    }
}
