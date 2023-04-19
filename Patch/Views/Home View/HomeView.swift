//
//  HomeView.swift
//  Patch
//
//  Created by Nate Leake on 4/3/23.
//

import SwiftUI

struct HomeView: View {
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
            .environmentObject(ColorContent())
    }
}
