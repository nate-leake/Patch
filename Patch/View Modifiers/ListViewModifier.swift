//
//  ListViewModifier.swift
//  Patch
//
//  Created by Nate Leake on 7/22/23.
//

import SwiftUI

struct ListViewModifier: ViewModifier {
    @EnvironmentObject var colors: ColorContent
    
    func body(content: Content) -> some View {
        content
            .listRowBackground(colors.ListViewElementBackground)
    }
}


extension View {
    func customListElementSyle() -> some View {
        self.modifier(ListViewModifier())
    }
}
