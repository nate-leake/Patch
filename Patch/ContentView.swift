//
//  ContentView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color(.blue)
                .ignoresSafeArea()
            Text("Content View")
                .foregroundColor(.white)
                .font(.system(size:30))
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
