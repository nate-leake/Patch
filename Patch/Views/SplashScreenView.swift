//
//  SplashScreenView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI
import SwiftData

struct SplashScreenView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var monthViewing: CurrentlyViewedMonth
    @EnvironmentObject var startingBalancesStore: StartingBalanceStore
    @EnvironmentObject var templatesStore: TemplatesStore
    
    @Query private var accountData: [Account]
    
    @State private var isActive = false
    
    func validateContext(){
        if accountData.isEmpty {
            context.insert(Account(name: "Default Checking", type: "Checking"))
            print("No accounts existed. Added \"Default Checking\"")
        }
    }
    
    var body: some View {
        if isActive == true{
            RootView()
                .environmentObject(colors)
                .environmentObject(monthViewing)
                .environmentObject(startingBalancesStore)
                .environmentObject(templatesStore)
                .onAppear{
                    colors.setPreferredColorScheme()
                }
            
        } else {
            ZStack{
                colors.Fill
                    .ignoresSafeArea()
                VStack(spacing: 0){
                    Image("SplashLogo")
                        .resizable()
                        .opacity(1.0)// Make it resizable
                        .aspectRatio(contentMode: .fit)  // Specifying the resizing mode so that image scaled correctly
                        .padding(.horizontal, 100)
                    
                    Text("Patch")
                        .font(.custom("Arial Rounded MT Bold", size: 75))
                    
                    
                }
                
                
                .overlay {
                    
                    LinearGradient(
                        colors: [colors.Primary, colors.Tertiary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .mask {
                        VStack(spacing: 0){
                            Image("SplashLogo")
                                .resizable()                     // Make it resizable
                                .aspectRatio(contentMode: .fit)  // Specifying the resizing mode so that image scaled correctly
                                .padding(.horizontal, 100)
                            Text("Patch")
                                .font(.custom("Arial Rounded MT Bold", size: 75))
                        }
                    }
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        withAnimation{
                            self.isActive = true
                        }
                        
                    }
                    validateContext()
                }
            }
            
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        SplashScreenView()
            .environmentObject(ColorContent())
            .environmentObject(CurrentlyViewedMonth())
        
    }
}
