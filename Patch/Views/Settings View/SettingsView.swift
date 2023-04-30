//
//  SettingsView.swift
//  Patch
//
//  Created by Nate Leake on 4/3/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var colors:ColorContent
    var body: some View {
        ZStack{
            VStack{
                NavigationStack{
                    ZStack{
                        colors.Fill
                            .ignoresSafeArea()
                        VStack{
                            Rectangle()
                                .frame(height: 0)
                                .background(colors.Fill)
                            
                            List {
                                NavigationLink{
                                    ZStack{
                                        colors.Fill
                                            .ignoresSafeArea()
                                        List{
                                            HStack{
                                                Text("Original")
                                                PaletteView(paletteName: "Original")
                                            }
                                            .onTapGesture {
                                                colors.setColorPalette(name: "Original")
                                                colors.colorScheme = .unspecified
                                            }
                                            
                                            HStack{
                                                Text("Pleasant")
                                                PaletteView(paletteName: "Pleasant")
                                            }.onTapGesture {
                                                colors.setColorPalette(name: "Pleasant")
                                                colors.colorScheme = .unspecified
                                            }
                                            
                                            HStack{
                                                Text("Terminal")
                                                PaletteView(paletteName: "Terminal")
                                            }.onTapGesture {
                                                colors.setColorPalette(name: "Terminal")
                                                colors.colorScheme = .dark
                                            }
                                        }.scrollContentBackground(.hidden)
                                    }
                                } label: {
                                    Text("Color Palette")
                                    
                                }
                                
                            }.scrollContentBackground(.hidden)
                            
                        }
                    }
                    .navigationTitle("Settings")
                    .foregroundColor(colors.Primary)
                }
            }
            .foregroundColor(colors.Primary)
            .font(.system(.body))
        }            
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ColorContent())
    }
}
