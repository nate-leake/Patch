//
//  SettingsView.swift
//  Patch
//
//  Created by Nate Leake on 4/3/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var colors:ColorContent
    
    let buildNumber: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let versionNumber: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
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
                                
                            }.scrollContentBackground(.hidden)
                            
                        }
                    }
                    .navigationTitle("Settings")
                    .foregroundColor(colors.Primary)
                }
                
                
                HStack{
                    Text("Version " + versionNumber)
                    Text("(" + buildNumber + ")")
                }.opacity(0.8)
            }
            .foregroundColor(colors.Primary)
            .font(.system(.body))
            
            
        }
        .transition(.move(edge: .trailing))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ColorContent())
    }
}
