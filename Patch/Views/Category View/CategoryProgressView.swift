//
//  CategoryProgressView.swift
//  Patch
//
//  Created by Nate Leake on 4/29/23.
//

import SwiftUI

struct CategoryProgressView: View {
    @EnvironmentObject var colors: ColorContent
    
    @State var image: String
    @State var percentage: Double
    
    private let gradient = AngularGradient(
        gradient: Gradient(colors: [Color.green.opacity(0.5), Color.pink.opacity(0.7), Color.blue.opacity(1.0)]),
        center: .center,
        startAngle: .degrees(0),
        endAngle: .degrees(190)
    )
    
    var body: some View {
        VStack(){
            CircularProgressView(progress: percentage/100.0)
                .overlay(
                    VStack(spacing: 0){
                        Spacer()
                        Image(systemName: image)
                            .font(.system(.title))
                        Spacer()
                    }
                )
                .padding(5)
        }
    }
}

struct CategoryProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryProgressView(image: "hazardsign", percentage: 30.00)
            .environmentObject(ColorContent())
    }
}
