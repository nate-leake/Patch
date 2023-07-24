//
//  BalancesView.swift
//  Patch
//
//  Created by Nate Leake on 6/30/23.
//

import SwiftUI

struct BalancesView: View {
    @EnvironmentObject var colors : ColorContent
    @EnvironmentObject var startingBalancesStore: StartingBalanceStore
    
    let dateFormatter = DateFormatter()
    let numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    
    init(){
        self.dateFormatter.dateFormat = "MMMM, yyyy"
    }
    
    var body: some View {
        NavigationLink{
            ZStack{
                colors.Fill
                    .ignoresSafeArea()
                NavigationStack{
                    
                    List (startingBalancesStore.balances.reversed(), id:\.self) { balance in
                        HStack{
                            Text("\(dateFormatter.string(from: balance.month))")
                            Spacer()
                            Text("\(numberFormatHandler.formatInt(value: Int(balance.startingBalance)))")
                        }
                        .customListElementSyle()
                    }
                    .scrollContentBackground(.hidden)
                }
                .navigationTitle("Starting Balances")
                
            }
        } label: {
            Text("Starting Balances")
        }
    }
}

struct BalancesView_Previews: PreviewProvider {
    static var previews: some View {
        BalancesView()
            .environmentObject(ColorContent())
            .environmentObject(StartingBalanceStore())
    }
}
