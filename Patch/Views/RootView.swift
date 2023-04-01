//
//  ContentView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

let colorPrimary = Color("Original_Primary")
let colorSecondary = Color("Original_Secondary")
let colorTertiary = Color("Original_Tertiary")
let colorAccent = Color("Original_Accent")


struct RootView: View {
        
    @State var selectedTabs: Tabs = .home
    
    
    var body: some View {
        ZStack{
            Color(.white)
                .ignoresSafeArea()
            
            VStack{
                Text("Content View")
                    .foregroundColor(colorAccent)
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
    }
}
