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
    case personal = "Personal"
    case houseing = "Housing"
    case healt = "Health"
    case food = "Food"
    case finance = "Finance"
    case none = ""
}

let symbols : [String: [String]] = [
    "Finance": [
        "creditcard","giftcard","dollarsign","banknote","chart.xyaxis.line"
    ],
    
    "Food": [
        "frying.pan","popcorn","stove","cart.fill","refrigerator","takeoutbag.and.cup.and.straw","wineglass","fork.knife","carrot","cup.and.saucer"
    ],
    
    "Health": [
        "list.bullet.clipboard","pills.fill","ivfluid.bag","cross.vial","medical.thermometer.fill","brain.filled.head.profile","ear.badge.waveform","eyedropper","syringe","stethoscope"
    ],
    
    "Housing": [
        "house","chandelier","door.left.hand.closed","flame.fill","bolt.fill","drop.fill","antenna.radiowaves.left.and.right","wrench.and.screwdriver.fill"
    ],
    
    "Personal": [
        "bathtub.fill","balloon.fill","tshirt.fill","person.fill","pencil","books.vertical.fill","comb.fill","eyeglasses","gift","eyebrow"
    ],
    
    "Tech": [
        "airtag","display","server.rack","iphone","computermouse","dot.radiowaves.up.forward","externaldrive","gamecontroller","cpu"
    ],
    
    "Transportation": [
        "figure.walk","airplane.departure","car","bus","tram","ferry","bicycle","fuelpump","suitcase.rolling.fill","tent"
    ]
]
