//
//  UIOptionsView.swift
//  Patch
//
//  Created by Nate Leake on 5/8/23.
//

import SwiftUI

struct UIOptionsView: View {
    @EnvironmentObject var colors : ColorContent
    
    @AppStorage("SHOW_UI_FIGURES_DOLLARS") var saved_Setting = false
    
    var body: some View {
        NavigationLink{
            ZStack{
                colors.Fill
                    .ignoresSafeArea()
                
                List{
                    ColorPaletteSelectorView()
                    Toggle("Show Figure Dollars", isOn: $saved_Setting)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("UI Options")
        } label: {
            Text("UI Options")
        }
    }
}

struct UIOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        UIOptionsView()
            .environmentObject(ColorContent())
    }
}
