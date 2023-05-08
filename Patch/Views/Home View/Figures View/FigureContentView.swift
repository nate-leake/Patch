//
//  FigureContentView.swift
//  Patch
//
//  Created by Nate Leake on 4/4/23.
//

import SwiftUI

struct FigureContentView: View {
    @EnvironmentObject var colors:ColorContent
    
    let title: String
    let percentage: Double
    let image: String
    
    var body: some View {
        VStack(spacing: 0){
            Text(title)
                .foregroundColor(colors.Primary)
                .padding(.bottom, 5)
            
            CircularProgressView(progress: percentage/100.0)
                .overlay(
                    VStack(spacing: 0){
                        Spacer()
                        Text(String(percentage)+"%")
                            .font(.system(.caption2))
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                        Spacer()
                    }
                )
                .padding(5)
//            Text("$43.98")
//                .font(.system(.footnote))
        }        
    }
}

struct FigureContentView_Previews: PreviewProvider {
    static var previews: some View {
        FigureContentView(title:"Income", percentage: 10.11, image:"expenses")
            .environmentObject(ColorContent())
    }
}
