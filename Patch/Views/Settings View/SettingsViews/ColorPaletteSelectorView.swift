//
//  ColorPaletteSelectorView.swift
//  Patch
//
//  Created by Nate Leake on 5/8/23.
//

import SwiftUI

struct ColorPaletteSelectorView: View {
    @EnvironmentObject var colors: ColorContent
    
    var body: some View {
        NavigationLink{
            ZStack{
                colors.Fill
                    .ignoresSafeArea()
                
                GeometryReader { geo in
                    List{
                        
                        HStack{
                            Text("Original")
                            Spacer()
                            PaletteView(paletteName: "Original")
                                .frame(width: geo.size.width * 0.55)
                        }
                        .onTapGesture {
                            colors.setColorPalette(name: "Original")
                            colors.colorScheme = .unspecified
                        }
                        
                        HStack{
                            Text("Pleasant")
                            Spacer()
                            PaletteView(paletteName: "Pleasant")
                                .frame(width: geo.size.width * 0.55)
                        }.onTapGesture {
                            colors.setColorPalette(name: "Pleasant")
                            colors.colorScheme = .unspecified
                        }
                        
                        HStack{
                            Text("Terminal")
                            Spacer()
                            PaletteView(paletteName: "Terminal")
                                .frame(width: geo.size.width * 0.55)
                        }.onTapGesture {
                            colors.setColorPalette(name: "Terminal")
                            colors.colorScheme = .dark
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
            }
        } label: {
            Text("Color Palette")
        }
    }
}

struct ColorPaletteSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteSelectorView()
            .environmentObject(ColorContent())
    }
}
