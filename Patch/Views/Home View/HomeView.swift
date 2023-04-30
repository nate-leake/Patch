//
//  HomeView.swift
//  Patch
//
//  Created by Nate Leake on 4/3/23.
//

import SwiftUI

struct HomeView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var colors:ColorContent
    
    var body: some View {
        ZStack{
            colors.Fill
                .ignoresSafeArea()
            GeometryReader{metrics in
                
                ScrollView{
                    VStack{
                        FiguresView()
                            .padding(10)
                            .frame(width: metrics.size.width, height: metrics.size.height*0.25)
                        
                        
                        Spacer()
                        
                        TransactionsView()
                            .environmentObject(dataController)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(DataController(isPreviewing: true))
            .environmentObject(ColorContent())
    }
}
