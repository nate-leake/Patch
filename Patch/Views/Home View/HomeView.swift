//
//  HomeView.swift
//  Patch
//
//  Created by Nate Leake on 4/3/23.
//

import SwiftUI

struct HomeView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        ZStack{
            colors.Fill
            
            ScrollView{
                VStack{
                    FiguresView()
                        .padding(.horizontal, 15)
                        .padding(.top, 5)
                    
                    Spacer()
                    
                    TransactionsView()
                        .environmentObject(dataController)
                    Spacer()
                }
            }
        }
        .transition(.move(edge: .leading))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, dataController.context)
            .environmentObject(dataController)
            .environmentObject(ColorContent())
    }
}
