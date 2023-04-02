//
//  ContentView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var colors:ColorContent
    
    @State var selectedTabs: Tabs = .accounts
    var body: some View {
        
        ZStack{
            colors.Fill
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Accent")
                    .foregroundColor(colors.Accent)
                    .font(.system(size:30))
                Spacer()
                Text("Primary")
                    .foregroundColor(colors.Primary)
                    .font(.system(size:30))
                Spacer()
                Text("Secondary")
                    .foregroundColor(colors.Secondary)
                    .font(.system(size:30))
                Spacer()
                Text("Tertiary")
                    .foregroundColor(colors.Tertiary)
                    .font(.system(size:30))
                Spacer()
                
                
                
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
