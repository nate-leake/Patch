//
//  SettingsView.swift
//  Patch
//
//  Created by Nate Leake on 4/3/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var colors:ColorContent
    @EnvironmentObject var startingBalancesStore: StartingBalanceStore

    
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
                                ColorPaletteSelectorView()
                                
                                UIOptionsView()
                                
                                BalancesView()
                                
                            }.scrollContentBackground(.hidden)
                            
                        }
                    }
                    .navigationTitle("Settings")
                    .foregroundColor(colors.InputText)
                }
                
                
                HStack{
                    Text("Version " + versionNumber)
                    Text("(" + buildNumber + ")")
                }.opacity(0.8)
            }
            .foregroundColor(colors.InputText)
            .font(.system(.body))
            
            
        }
        .transition(.move(edge: .trailing))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ColorContent())
            .environmentObject(StartingBalanceStore())
    }
}
