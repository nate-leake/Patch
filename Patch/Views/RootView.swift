//
//  ContentView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var colors:ColorContent
    
    @State var selectedTabs: Tabs = .home
    
    var body: some View {
        
        ZStack{
            colors.Fill
                .ignoresSafeArea()
            
            VStack{
                
                switch selectedTabs {
                case .home:
                    HomeView()
                case .categories:
                    CategoryView()
                case .accounts:
                    AccountsView()
                case .settings:
                    SettingsView()
                }
                
                CustomTabBar(selectedTab: $selectedTabs)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(ColorContent())
    }
}
