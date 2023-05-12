//
//  CircularProgressView.swift
//  Patch
//
//  Created by Nate Leake on 4/5/23.
//

import SwiftUI

struct CircularProgressView: View {
    @EnvironmentObject var colors: ColorContent
    
    @State var angularGradient: AngularGradient = AngularGradient(
        gradient: Gradient(colors: [Color.green.opacity(0.6), Color.green.opacity(1.0)]),
        center: .center,
        startAngle: .degrees(0),
        endAngle: .degrees(359)
    )
    //                .stroke(gradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))
    @State var gradient: Gradient = Gradient(colors: [Color.green.opacity(1.0), Color.green.opacity(1.0)])
    @State var leadingOpacity: Double = 1.0
    @State var trailingOpacity: Double = 1.0
    
    let progress: Double
    
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    angularGradient.opacity(0.5),
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .butt
                    )
                )
                .rotationEffect(.degrees(-90))
            
            Circle()
            // 2
                .trim(from: 0, to: progress)
                .stroke(
                    angularGradient,
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                        
                    )
                )
                .rotationEffect(.degrees(-90))
        }
        .onAppear(
            perform: {
                self.gradient = Gradient(colors: [colors.ProgressCircleFill.opacity(self.leadingOpacity), colors.ProgressCircleFill.opacity(self.trailingOpacity)])
                
                
                self.angularGradient = AngularGradient(
                    gradient: self.gradient,
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(359)
                )
            }
        )
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.99)
            .environmentObject(ColorContent())
    }
}
