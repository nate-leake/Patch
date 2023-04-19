//
//  TransactionDetailTileView.swift
//  Patch
//
//  Created by Nate Leake on 4/12/23.
//

import SwiftUI

struct TransactionDetailTileView: View {
    @EnvironmentObject var colors: ColorContent
    var title: String
    var content: AnyView
    
    var cornerRadius: CGFloat = 16
    
    @State private var dateSelected: Date = Date()
    
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
        TransactionDetailTileView(title: "Date", content: AnyView(Text("Content")))
            .environmentObject(ColorContent())
    }
}
