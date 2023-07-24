//
//  UIOptionsView.swift
//  Patch
//
//  Created by Nate Leake on 5/8/23.
//

import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject var colors : ColorContent
    
    @AppStorage("SHOW_UI_FIGURES_DOLLARS") var saved_Setting = false
    
    var body: some View {
        NavigationLink{
            ZStack{
                colors.Fill
                    .ignoresSafeArea()
                
                List{
                    ColorPaletteSelectorView()
                        .customListElementSyle()
                    Toggle("Show Figure Dollars", isOn: $saved_Setting)
                        .customListElementSyle()
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Appearance")
        } label: {
            Text("Appearance")
        }
    }
}

struct UIOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
            .environmentObject(ColorContent())
    }
}
