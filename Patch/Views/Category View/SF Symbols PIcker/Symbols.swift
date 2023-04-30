//
//  File.swift
//
//
//  Created by Alessio Rubicini on 06/01/21.
//

import Foundation

public enum SFCategory: String, CaseIterable, Identifiable {
    public var id: String { rawValue }
    
    case transport = "Transportation"
    case tech = "Tech"
    case houseing = "Housing"
    case food = "Food"
    case finance = "Finance"
    case none = ""
}

let symbols : [String: [String]] = [
    "Finance": [
        "creditcard", "giftcard", "dollarsign", "banknote"
    ],
    "Food": [
        "frying.pan","popcorn","stove","cooktop","refrigerator","takeoutbag.and.cup.and.straw","wineglass","fork.knife","carrot","cup.and.saucer"
    ],
    "Housing": [
        "house", "house.lodge", "chandelier", "door.left.hand.closed"
    ],
    "Tech": [
        "airtag","display","server.rack","iphone","computermouse","dot.radiowaves.up.forward", "externaldrive"
    ],
    "Transportation": [
        "figure.walk", "airplane.departure","car","bus","tram","ferry","bicycle","fuelpump"
    ]
]
