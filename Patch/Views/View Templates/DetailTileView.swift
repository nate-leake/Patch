//
//  TransactionDetailTileView.swift
//  Patch
//
//  Created by Nate Leake on 4/12/23.
//

import SwiftUI

struct DetailTileView: View, Identifiable {
    @EnvironmentObject var colors: ColorContent
    var id: UUID = UUID()
    var title: String
    
    @ViewBuilder
    var content: AnyView
    var borderColor = Color(.gray)
    
    var cornerRadius: CGFloat = 16
    
    @State private var dateSelected: Date = Date()
    
    init(title: String, content: AnyView, borderColor: Color = Color(.gray)) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(colors.Fill)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            colors.Tertiary, lineWidth: 4)
                )
            
            HStack{
                VStack{
                    Text(title)
                        .font(.system(.title3))
                        .padding(.top, 10)
                    Spacer()
                    content
                    Spacer()
                    
                }
            }
        }
    }
}

struct TransactionDetailTileView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTileView(title: "Date", content: AnyView(Text("Content")))
            .environmentObject(ColorContent())
    }
}
