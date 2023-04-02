//
//  Profile.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import Foundation
import SwiftUI

class ColorContent: ObservableObject {
    
    @Published var Palette = "System"
    
    @Published var Primary: Color
    @Published var Fill: Color
    @Published var Secondary: Color
    @Published var Tertiary: Color
    @Published var Accent: Color
    
    
    init(){
        self.Primary   = Color("System_Primary")
        self.Fill      = Color("System_Fill")
        self.Secondary = Color("System_Secondary")
        self.Tertiary  = Color("System_Tertiary")
        self.Accent    = Color("System_Accent")
    }
    
    func setColorPalett(name:String){
        if name == "Pleasant"{
            self.Primary   = Color("Pleasant_Primary")
            self.Fill      = Color("Pleasant_Fill")
            self.Secondary = Color("Pleasant_Secondary")
            self.Tertiary  = Color("Pleasant_Tertiary")
            self.Accent    = Color("Pleasant_Accent")
        }
        
        else if name == "System"{
            self.Primary   = Color("System_Primary")
            self.Fill      = Color("System_Fill")
            self.Secondary = Color("System_Secondary")
            self.Tertiary  = Color("System_Tertiary")
            self.Accent    = Color("System_Accent")
        }
        
        else {
            self.Primary   = Color("Original_Primary")
            self.Fill      = Color("Original_Fill")
            self.Secondary = Color("Original_Secondary")
            self.Tertiary  = Color("Original_Tertiary")
            self.Accent    = Color("Original_Accent")
        }
        
    }
    
}
