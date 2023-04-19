//
//  PaletteView.swift
//  Patch
//
//  Created by Nate Leake on 4/6/23.
//

import SwiftUI

struct PaletteView: View {
        
    var paletteName: String
    
    var body: some View {
        VStack{
            HStack(spacing: 0){
                Rectangle().fill(Color(paletteName+"_Fill"))
                Rectangle().fill(Color(paletteName+"_Primary"))
                Rectangle().fill(Color(paletteName+"_Secondary"))
                Rectangle().fill(Color(paletteName+"_Tertiary"))
                Rectangle().fill(Color(paletteName+"_Accent"))
                
            }
        }
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView(paletteName: "Original")
    }
}
