//
//  SplashScreenView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var monthViewing: CurrentlyViewedMonth
    @EnvironmentObject var startingBalancesStore: StartingBalanceStore
    @EnvironmentObject var templatesStore: TemplatesStore
    
    @State private var isActive = false
    
    var body: some View {
        if isActive == true{
            RootView()
                .environment(\.managedObjectContext, dataController.context)
                .environmentObject(colors)
                .environmentObject(dataController)
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
                }
            }
            .onAppear(
                perform: {dataController.computations.checking.monthViewing = self.monthViewing}
            )
            
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var dataController: DataController = DataController()
    
    static var previews: some View {
        SplashScreenView()
            .environment(\.managedObjectContext, dataController.context)
            .environmentObject(dataController)
            .environmentObject(ColorContent())
            .environmentObject(CurrentlyViewedMonth(MOC: dataController.context))
        
    }
}
