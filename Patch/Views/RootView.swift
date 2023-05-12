//
//  ContentView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

struct RootView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var dataController: DataController
    
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
    static var dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        RootView()
            .environmentObject(dataController)
            .environmentObject(ColorContent())
            .environment(\.managedObjectContext, dataController.context)
    }
}
