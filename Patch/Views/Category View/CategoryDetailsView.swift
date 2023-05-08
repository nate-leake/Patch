//
//  AddCategoryView.swift
//  Patch
//
//  Created by Nate Leake on 4/22/23.
//

import SwiftUI

struct CategoryDetailsView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var colors: ColorContent
    
    @Environment(\.dismiss) var dismissSheet
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var accountData: FetchedResults<Account>
    
    var editingCategory: Category?
    
    @State var limitAmount: Int = 0
    @State var name: String = ""
    @State var typeSelection: String = "Expense"
    let categoryTypeOptions = ["Income", "Expense"]
    
    @State var accountSelection : Account?
    
    var isEditing: Bool = false
    
    @State var submitText: String = "Add"
    var sheetTitle: String = "Category Details"
    
    var numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    
    var category: FetchedResults<Category>.Element?
    
    
    @State private var icon = "l1.rectangle.roundedbottom"
    @State var sfCategory: SFCategory = .food
    
    
    init(name: String = "", limitAmount: Int = 0, category: Category? = nil) {
        if let t = category {
            self.editingCategory = t
            self.isEditing = true
            return
        }
    }
    
    var width: CGFloat = .infinity
    var height: CGFloat = 100
    private let  adaptiveColumns = [
        GridItem(.adaptive(minimum: .infinity))
    ]
    
    func validateInputs() -> Bool{
        if (name != "" && limitAmount != 0 && typeSelection != ""){
            if isEditing {
                dataController.editCategory(category: editingCategory!, name: name, limit: limitAmount, type: typeSelection, symbolName: icon)
            } else {
                dataController.addCategory(account: accountData[0],name: name, limit: limitAmount, type: typeSelection, symbolName: icon)
            }
            return true
        } else {
            return false
        }
    }
    
    
    var body: some View {
        ZStack{
            colors.Fill.ignoresSafeArea()
            VStack{
                CustomSheetHeaderView(validateFeilds: validateInputs, sheetTitle: "Category Details", submitText: self.submitText)
                
                VStack{
                    LazyVGrid(columns: adaptiveColumns, spacing: 20){
                        DetailTileView(
                            title: "Name",
                            content: AnyView(
                                TextField("Name this category", text: $name)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(colors.InputText)
                            )
                        )
                        
                        
                        DetailTileView(
                            title: "Limit",
                            content: AnyView(
                                CurrencyField(value: $limitAmount)
                                    .padding(.horizontal, 20)
                                    .foregroundColor(colors.InputText)
                                    .font(.system(.title2))
                            )
                        )
                        
                        DetailTileView(
                            title: "Type",
                            content: AnyView(
                                Menu{
                                    ForEach(categoryTypeOptions, id: \.self){type in
                                        Button(type){
                                            typeSelection = type
                                        }
                                    }
                                } label: {
                                    Label(
                                        title: {Text(typeSelection).frame(width: 150)},
                                        icon: {}
                                    )
                                }
                                    .foregroundColor(colors.InputSelect)
                                
                            )
                            
                        )
                        
                        DetailTileView(
                            title: "Account",
                            content: AnyView(
                                Menu{
                                    ForEach(accountData){account in
                                        Button(account.name!){
                                            accountSelection = account
                                        }
                                    }
                                } label: {
                                    Label(
                                        title: {Text((accountSelection?.name! ?? accountData[0].name) ?? "Choose").frame(width: 150)},
                                        icon: {}
                                    )
                                }
                                    .foregroundColor(colors.InputSelect)
                            )
                        )
                        
                        DetailTileView(
                            title: "Icon",
                            content: AnyView(
                                VStack{
                                    Menu{
                                        ForEach(SFCategory.allCases, id: \.id) { value in
                                            if value.rawValue != "" {
                                                Button(value.rawValue){
                                                    sfCategory = value
                                                }
                                            }
                                        }
                                    } label: {
                                        Label(
                                            title: {Text(sfCategory.rawValue).frame(width: 150)},
                                            icon: {}
                                        )
                                    }
                                    
                                    .foregroundColor(colors.InputSelect)
                                    
                                    
                                    SFSymbolsPicker(icon: $icon, category: sfCategory, axis: .vertical, haptic: true)
                                        .padding(.horizontal, 30)
                                }
                            )
                        )
                    }
                    .onAppear(
                    perform: {
                        if self.isEditing{
                            self.name = self.editingCategory?.title ?? ""
                            self.limitAmount = Int(self.editingCategory?.limit ?? 000)
                            self.typeSelection = self.editingCategory?.type ?? "Expense"
                            self.accountSelection = self.editingCategory?.account
                            self.submitText = "Save"
                            self.icon = self.editingCategory?.symbolName ?? "nosign"
                            
                            print("category: "+self.name)
                            print("\(self.limitAmount)")
                        }
                    }
                    )
                    
                    Spacer()
                    
                }.foregroundColor(colors.Primary)
                    .padding(.top, 50.0)
                
            }
            .padding(.horizontal, 20)
        }
        
        
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        CategoryDetailsView()
            .environmentObject(DataController(isPreviewing: true))
            .environmentObject(ColorContent())
            .environment(\.managedObjectContext, dataController.context)
    }
}
