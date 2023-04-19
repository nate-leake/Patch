//
//  Accounts View.swift
//  Patch
//
//  Created by Nate Leake on 4/4/23.
//

import SwiftUI

struct AccountsView: View {
    @EnvironmentObject var colors:ColorContent
    
    var body: some View {
        ZStack{
            colors.Fill
                .ignoresSafeArea()
            Text("Account View")
                .foregroundColor(colors.Primary)
        }
    }
}

struct Accounts_View_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
            .environmentObject(ColorContent())
    }
}
