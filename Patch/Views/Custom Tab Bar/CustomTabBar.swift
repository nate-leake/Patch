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
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        HStack{
            Button{
                selectedTab = .home
            } label: {
                TabBarButton(buttonText: "Home", imageName: "chart.line.uptrend.xyaxis.circle", isActive: selectedTab == .home)
            }
            .tint(colorSecondary)
            
            
            Button{
                selectedTab = .categories
            } label: {
                TabBarButton(buttonText: "Categories", imageName: "chart.bar.doc.horizontal", isActive: selectedTab == .categories)
            }
            .tint(colorSecondary)
            
            Button{
                selectedTab = .accounts
            } label: {
                TabBarButton(buttonText: "Accounts", imageName: "creditcard", isActive: selectedTab == .accounts)
            }
            .tint(colorSecondary)
            
            
        }
        .frame(height: 82)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.home))
    }
}
