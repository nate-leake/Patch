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
    @EnvironmentObject var monthViewing: CurrentlyViewedMonth
    
    
    
    var body: some View {
        ZStack{
            colors.Fill
            
            ScrollView{
                VStack{
                    FiguresView(calculations: monthViewing.calculations)
                        .padding(.horizontal, 15)
                        .padding(.top, 5)
                    
                    Spacer()
                                        
                    TransactionsView(monthViewing: self.monthViewing)
                        .environmentObject(self.dataController)
                        .environmentObject(self.monthViewing)
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
            .environmentObject(CurrentlyViewedMonth(MOC: dataController.context))
    }
}
