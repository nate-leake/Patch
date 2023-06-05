//
//  MonthSelectorView.swift
//  Patch
//
//  Created by Nate Leake on 5/30/23.
//

import SwiftUI

struct MonthSelectorView: View {
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var monthViewing: CurrentlyViewedMonth
    
    let monthDateFormatter = DateFormatter()
    
    init(){
        monthDateFormatter.dateFormat = "MMM"
    }
    
    var body: some View {
        HStack(spacing: 20){
            Button(action: monthViewing.viewLastMonth, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(colors.Secondary)
                
            })
            Text("\(monthDateFormatter.string(from: monthViewing.monthStart))")
            Button(action: monthViewing.viewNextMonth, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(colors.Secondary)
                
            })
        }
    }
}

struct MonthSelectorView_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    static var previews: some View {
        MonthSelectorView()
            .environmentObject(ColorContent())
            .environmentObject(CurrentlyViewedMonth(MOC: dataController.context))
    }
}
