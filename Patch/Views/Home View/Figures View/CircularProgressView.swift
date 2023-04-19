//
//  CircularProgressView.swift
//  Patch
//
//  Created by Nate Leake on 4/5/23.
//

import SwiftUI

struct CircularProgressView: View {
    @EnvironmentObject var colors: ColorContent
    
    let progress: Double
    
    private let gradient = AngularGradient(
        gradient: Gradient(colors: [Color.green.opacity(0.5), Color.green.opacity(0.7), Color.green.opacity(0.5)]),
        center: .center,
        startAngle: .degrees(0),
        endAngle: .degrees(190))
    //                .stroke(gradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))

    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.green.opacity(0.5),
                    lineWidth: 5
                )
            Circle()
                // 2
                .trim(from: 0, to: progress)
                .stroke(
                    Color.green,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.764)
            .environmentObject(ColorContent())
    }
}
