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
        "creditcard","doc.text","chart.pie","dollarsign","arrow.right.square","percent","banknote","chart.xyaxis.line","giftcard"
    ],
    
    "Food": [
        "frying.pan","popcorn","stove","cart.fill","refrigerator","takeoutbag.and.cup.and.straw","wineglass","fork.knife","carrot","cup.and.saucer"
    ],
    
    "Health": [
        "list.bullet.clipboard","pills.fill","ivfluid.bag","cross.vial","medical.thermometer.fill","brain.filled.head.profile","ear.badge.waveform","eyedropper","syringe","stethoscope"
    ],
    
    "Housing": [
        "drop","powerplug","flame","antenna.radiowaves.left.and.right","chair.lounge","lamp.table","web.camera","house","door.left.hand.closed","wrench.and.screwdriver.fill"
    ],
    
    "Personal": [
        "bathtub.fill","balloon.fill","tshirt.fill","person.fill","pencil","books.vertical.fill","comb.fill","eyeglasses","gift","eyebrow"
    ],
    
    "Tech": [
        "display","iphone","computermouse","airtag","gamecontroller","mic","dot.radiowaves.up.forward","externaldrive","server.rack","cpu"
    ],
    
    "Transportation": [
        "figure.walk","airplane.departure","car","bus","tram","ferry","bicycle","fuelpump","suitcase.rolling.fill","tent"
    ]
]
