//
//  TransactionsView.swift
//  Patch
//
//  Created by Nate Leake on 4/10/23.
//

import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject var colors:ColorContent
    
    @State var showTransactionSheet: Bool = false
    
    var body: some View {
        LazyVStack{
            HStack(){
                Spacer()
                Image(systemName: "plus.app")
                    .padding(.vertical, 2.0)
                    .padding(.horizontal, 12.0)
                    .foregroundColor(colors.Accent)
                    .font(.system(.largeTitle))
                    .onTapGesture {
                        showTransactionSheet.toggle()
                    }
            }
            .sheet(isPresented: $showTransactionSheet, content: {
                AddTransactionView()
                
            })
        }
        
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
            .environmentObject(ColorContent())
    }
}
