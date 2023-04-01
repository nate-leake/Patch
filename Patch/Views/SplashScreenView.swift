//
//  SplashScreenView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    let colorPrimary = Color("Original_Primary")
    let colorSecondary = Color("Original_Secondary")
    let colorTertiary = Color("Original_Tertiary")
    let colorAccent = Color("Original_Accent")
    
    
    var body: some View {
        if isActive == true{
            RootView()
        } else {
            VStack{
                    Image("P")
                        .resizable()                     // Make it resizable
                        .aspectRatio(contentMode: .fit)  // Specifying the resizing mode so that image scaled correctly
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }

                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
