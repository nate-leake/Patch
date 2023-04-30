//
//  CustomSheetView.swift
//  Patch
//
//  Created by Nate Leake on 4/24/23.
//

import SwiftUI

struct CustomSheetHeaderView: View {
    @EnvironmentObject var colors: ColorContent
    @Environment(\.dismiss) var dismissSheet
    
    var validateFeilds: () -> Bool
    var sheetTitle: String
    var submitText: String
    
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
        CustomSheetHeaderView(validateFeilds: testFunc, sheetTitle: "Custom Sheet", submitText: "Perform")
            .environmentObject(ColorContent())
        
    }
}
