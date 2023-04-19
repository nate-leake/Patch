//
//  TabBarButton.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

struct TabBarButton: View {
    @EnvironmentObject var colors: ColorContent
    
    var buttonText: String
    var imageName: String
    var isActive: Bool
    
    var body: some View {
        
            GeometryReader{ geo in
                
                if isActive{
                    Rectangle()
                        .foregroundColor(colors.Accent)
                        .frame(width: geo.size.width/2, height: 4)
                        .padding(.leading, geo.size.width/4)
                }
                
                VStack (alignment: .center, spacing: 4){
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text(buttonText)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        
    }
}

struct TabBarButton_Previews: PreviewProvider {
    static var previews: some View {
        TabBarButton(buttonText: "home", imageName: "creditcard", isActive: true)
            .environmentObject(ColorContent())
    }
}
