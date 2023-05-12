//
//  Profile.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import Foundation
import SwiftUI

enum ColorScheme: Int {
    case unspecified, light, dark
}


class ColorContent: ObservableObject {
    @Environment(\.colorScheme) var systemColorScheme
    
    @AppStorage("COLOR_SCHEME") var colorScheme: ColorScheme = .unspecified{
        didSet{
            setPreferredColorScheme()
        }
    }
    
    @Published var Accent: Color
    @Published var Fill: Color
    @Published var InputSelect: Color
    @Published var InputText: Color
    @Published var Palette = "Original"
    @Published var Primary: Color
    @Published var ProgressCircleFill: Color
    @Published var Secondary: Color
    @Published var Tertiary: Color
    
    var keyWindow: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    
    init(){
        UserDefaults.resetStandardUserDefaults()
        var saved_palette: String = UserDefaults.standard.string(forKey: "COLOR_PALETTE") ?? ""
        let saved_scheme: Int = UserDefaults.standard.integer(forKey: "COLOR_SCHEME")
        
        if saved_palette == ""{
            saved_palette = "Original"
            UserDefaults.standard.set(saved_palette, forKey: "COLOR_PALETTE")
        }
        
        self.Primary     = Color(saved_palette+"_Primary")
        self.Fill        = Color(saved_palette+"_Fill")
        self.Secondary   = Color(saved_palette+"_Secondary")
        self.Tertiary    = Color(saved_palette+"_Tertiary")
        self.Accent      = Color(saved_palette+"_Accent")
        self.InputText   = Color(saved_palette+"_InputText")
        self.InputSelect = Color(saved_palette+"_InputSelect")
        
        self.ProgressCircleFill = Color(saved_palette+"_ProgressCircleFill")
        
        switch saved_scheme{
        case 0: self.colorScheme = .unspecified
        case 1: self.colorScheme = .light
        case 2: self.colorScheme = .dark
        default:
            self.colorScheme = .unspecified
        }
    }
    
    func setColorPalette(name:String){
        UserDefaults.standard.set(name, forKey: "COLOR_PALETTE")
        self.Primary     = Color(name+"_Primary")
        self.Fill        = Color(name+"_Fill")
        self.Secondary   = Color(name+"_Secondary")
        self.Tertiary    = Color(name+"_Tertiary")
        self.Accent      = Color(name+"_Accent")
        self.InputText   = Color(name+"_InputText")
        self.InputSelect = Color(name+"_InputSelect")
        
        self.ProgressCircleFill = Color(name+"_ProgressCircleFill")
    }
    
    func setPreferredColorScheme(){
        keyWindow?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: colorScheme.rawValue)!
    }
    
}
