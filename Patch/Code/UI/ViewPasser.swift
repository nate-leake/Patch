//
//  ViewPasser.swift
//  Patch
//
//  Created by Nate Leake on 4/24/23.
//

import Foundation
import SwiftUI


struct ViewPasser: Identifiable{
    var id: UUID = UUID()
    var view: AnyView
    
    init(view: AnyView) {
        self.view = view
    }
}
