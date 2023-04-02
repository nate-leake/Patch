//
//  CustomTabBar.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

enum Tabs: Int {
    case home = 0
    case categories = 1
    case accounts = 2
}


struct CustomTabBar: View {
    @EnvironmentObject var colors:ColorContent
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        HStack{
            TabBarButton(buttonText: "Home", imageName: "chart.line.uptrend.xyaxis.circle", isActive: selectedTab == .home)
                .onTapGesture{
                    selectedTab = .home
                    colors.setColorPalett(name: "Original")
                }
                .foregroundColor(colors.Primary)
            
            
            TabBarButton(buttonText: "Categories", imageName: "chart.bar.doc.horizontal", isActive: selectedTab == .categories)
                .onTapGesture{
                    selectedTab = .categories
                    colors.setColorPalett(name: "Pleasant")
                }
                .foregroundColor(colors.Primary)
            
            
            
            TabBarButton(buttonText: "Accounts", imageName: "creditcard", isActive: selectedTab == .accounts)
                .onTapGesture {
                    
                    selectedTab = .accounts
                    colors.setColorPalett(name: "System")
                }
            
                .foregroundColor(colors.Primary)
            
            
        }
        .frame(height: 82)
        
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.home))
            .environmentObject(ColorContent())
    }
}
