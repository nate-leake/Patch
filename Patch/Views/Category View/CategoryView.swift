//
//  CategoryView.swift
//  Patch
//
//  Created by Nate Leake on 4/4/23.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var colors:ColorContent
    
    var body: some View {
        ZStack{
            colors.Fill
                .ignoresSafeArea()
            Text("Categories View")
                .foregroundColor(colors.Primary)
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
            .environmentObject(ColorContent())
    }
}
