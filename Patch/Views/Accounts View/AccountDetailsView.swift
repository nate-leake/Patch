//
//  AccountDetailsView.swift
//  Patch
//
//  Created by Nate Leake on 4/28/23.
//

import SwiftUI
import SwiftData

struct AccountDetailsView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var colors: ColorContent
    
    @Environment(\.dismiss) var dismissSheet
    @Query private var accountData: [Account]
    
    @State var name: String = ""
    @State var typeSelection = "Checking"
    
    let categoryTypeOptions = ["Checking"]
    
    var isEditing: Bool = false
    var numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    var sheetTitle: String = "Account Details"
    var submitText: String = "Add"
    
    
    init(name: String = "", limitAmount: Int = 0) {
        if (name != ""){
            print("Editing category named: \(name)")
            print(limitAmount)
            self.name = name
            self.isEditing = true
            self.submitText = "Save"
            self.sheetTitle = "Editing Category \(name)"
        }
    }
    
    var width: CGFloat = .infinity
    var height: CGFloat = 100
    private let  adaptiveColumns = [
        GridItem(.adaptive(minimum: .infinity))
    ]
    
    func validateInputs() -> Bool{
        if (name != "" && typeSelection != ""){
            let item = Account(name: name, type: typeSelection)
            context.insert(item)
            return true
        } else {
            return false
        }
    }
    
    
    var body: some View {
        ZStack{
            colors.Fill.ignoresSafeArea()
            VStack{
                CustomSheetHeaderView(sheetTitle: sheetTitle, submitText: submitText, validateFeilds: validateInputs)
                
                VStack{
                    LazyVGrid(columns: adaptiveColumns, spacing: 20){
                        DetailTileView(
                            title: "Name",
                            content: AnyView(
                                TextField("Name this account", text: $name)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                            )
                        )
                        
                        DetailTileView(
                            title: "Type",
                            content: AnyView(
//                                Picker("Select a type", selection: $typeSelection) {
//                                    ForEach(categoryTypeOptions, id: \.self) {
//                                        Text($0)
//                                    }
//                                }
//                                    .pickerStyle(.menu)
//                                    .foregroundColor(colors.Accent)
                                
                                Menu{
                                    ForEach(categoryTypeOptions, id: \.self) { option in
                                        
                                        Button(option){
                                            typeSelection = option
                                        }
                                        
                                    }
                                } label: {
                                    Label(
                                        title: {Text(typeSelection).frame(width: 150)},
                                        icon: {}
                                    )
                                }
                                
                                    .foregroundColor(colors.Accent)
                            )
                        )
                    }
                    
                    
                    Spacer()
                    
                }.foregroundColor(colors.Primary)
                    .padding(.top, 50.0)
                
            }
            .padding(.horizontal, 20)
        }
        
        
    }
}

struct AccountDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        AccountDetailsView()
            .environmentObject(ColorContent())
    }
}
