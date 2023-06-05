//
//  CustomSheetView.swift
//  Patch
//
//  Created by Nate Leake on 4/24/23.
//

import SwiftUI

struct CustomSheetHeaderView: View {
    @Environment(\.dismiss) var dismissSheet
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var monthViewing: CurrentlyViewedMonth
    
    var sheetTitle: String
    var submitText: String
    var validateFeilds: () -> Bool
    
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    dismissSheet()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(colors.Primary)
                        .font(.system(.title3))
                }
                
                Spacer()
                Button{
                    if validateFeilds() {
                        dismissSheet()
                        monthViewing.performFetchRequest()
                    }
                } label: {
                    Text(submitText)
                        .foregroundColor(colors.Primary)
                        .font(.system(.title3))
                }
            }
            .padding(.top, 25.0)
            .padding(.bottom, 5.0)
            
            Text(sheetTitle)
                .foregroundColor(colors.Primary)
                .font(.system(.title2))
        }
    }
}

struct CustomSheetView_Previews: PreviewProvider {
    static func testFunc() -> Bool{
        return true
    }
    static var previews: some View {
        CustomSheetHeaderView(sheetTitle: "Custom Sheet", submitText: "Perform", validateFeilds: testFunc)
            .environmentObject(ColorContent())
            .environmentObject(CurrentlyViewedMonth(MOC: DataController(isPreviewing: true).context))
        
    }
}
