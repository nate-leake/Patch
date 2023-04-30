//
//  AccountDetailsView.swift
//  Patch
//
//  Created by Nate Leake on 4/28/23.
//

import SwiftUI

struct AccountDetailsView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var colors: ColorContent
    
    @Environment(\.dismiss) var dismissSheet
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var accountData: FetchedResults<Account>
    
    @State var name: String = ""
    @State var typeSelection = "Checking"
    let categoryTypeOptions = ["Checking"]
    
    var isEditing: Bool = false
    
    var submitText: String = "Add"
    var sheetTitle: String = "Account Details"
    
    var numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    
    var category: FetchedResults<Category>.Element?
    
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
            dataController.addAccount(name: name, type: typeSelection)
            return true
        } else {
            return false
        }
    }
    
    
    var body: some View {
        ZStack{
            colors.Fill.ignoresSafeArea()
            VStack{
                CustomSheetHeaderView(validateFeilds: validateInputs, sheetTitle: sheetTitle, submitText: submitText)
                
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
    static let dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        AccountDetailsView()
            .environmentObject(ColorContent())
            .environment(\.managedObjectContext, dataController.context)
    }
}
