//
//  AddCategoryView.swift
//  Patch
//
//  Created by Nate Leake on 4/22/23.
//

import SwiftUI
import SwiftData

struct CategoryDetailsView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismissSheet
    @EnvironmentObject var colors: ColorContent
    
    @ObservedObject var monthViewing: CurrentlyViewedMonth
    
    //    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var accountData: FetchedResults<Account>
    @Query private var accountData: [Account]
    
    @FocusState private var isFocused: Bool
    
    @State private var icon = "questionmark"
    
    @State var accountSelection : Account?
    @State var limitAmount: Int = 0
    @State var name: String = ""
    @State var sfCategory: SFCategory = .food
    @State var submitText: String = "Add"
    @State var typeSelection: String = "Expense"
    
    @State var isShowingNameValidation = false
    @State var isShowingLimitValidation = false
    @State var isShowingTypeValidation = false
    
    @State var isShowingDeletionAlert = false
    
    let categoryTypeOptions = ["Income", "Expense"]
    
    var editingCategory: Category?
    var isEditing: Bool = false
    var numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    var sheetTitle: String = "Category Details"
    
    
    init(monthViewing: CurrentlyViewedMonth, name: String = "", limitAmount: Int = 0, category: Category? = nil) {
        self.monthViewing = monthViewing
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
    
    func addCategory(){
        if isEditing {
            editingCategory?.edit(date: monthViewing.monthStart, limit: limitAmount, symbolName: icon, title: name, type: typeSelection, account: accountData[0])
            try? context.save()
        } else {
            // create the item
            let item = Category(date: monthViewing.monthStart, limit: limitAmount, symbolName: icon, title: name, type: typeSelection, account: accountData[0])
            // add the item to the data context
            context.insert(item)
        }
    }
    
    func validateInputs() -> Bool{
        var returnState = true
        
        isShowingNameValidation = false
        isShowingLimitValidation = false
        isShowingTypeValidation = false
        
        if name == "" {
            isShowingNameValidation = true
            returnState = false
        }
        
        if limitAmount == 0 {
            isShowingLimitValidation = true
            returnState = false
        }
        
        if typeSelection == "" {
            isShowingTypeValidation = true
            returnState = false
        }
        
        if returnState == true {
            self.addCategory()
        }
        
        return returnState
    }
    
    
    var body: some View {
        ZStack{
            colors.Fill.ignoresSafeArea()
            VStack{
                CustomSheetHeaderView(sheetTitle: "Category Details", submitText: self.submitText, validateFeilds: validateInputs)
                
                VStack{
                    
                    if isShowingNameValidation{
                        Text("A name is required")
                            .foregroundColor(.red)
                    }
                    LazyVGrid(columns: adaptiveColumns, spacing: 20){
                        DetailTileView(
                            title: "Name",
                            content: AnyView(
                                TextField("Name this category", text: $name)
                                    .tint(colors.Primary)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(colors.InputText)
                            )
                        )
                        
                        if isShowingLimitValidation{
                            Text("Limit cannot be zero")
                                .foregroundColor(.red)
                        }
                        DetailTileView(
                            title: "Amount",
                            content: AnyView(
                                CurrencyField(value: $limitAmount)
                                    .padding(.horizontal, 20)
                                    .foregroundColor(colors.InputText)
                                    .font(.system(.title2))
                                    .focused($isFocused)
                            )
                        )
                        
                        if isShowingTypeValidation{
                            Text("Please select a type")
                                .foregroundColor(.red)
                        }
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
                        
                        //                        DetailTileView(
                        //                            title: "Account",
                        //                            content: AnyView(
                        //                                Menu{
                        //                                    ForEach(accountData){account in
                        //                                        Button(account.name!){
                        //                                            accountSelection = account
                        //                                        }
                        //                                    }
                        //                                } label: {
                        //                                    Label(
                        //                                        title: {Text((accountSelection?.name! ?? accountData[0].name) ?? "Choose").frame(width: 150)},
                        //                                        icon: {}
                        //                                    )
                        //                                }
                        //                                    .foregroundColor(colors.InputSelect)
                        //                            )
                        //                        )
                        
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
                    if isEditing && editingCategory?.transactions?.count == 0{
                        Spacer()
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.system(.title))
                            .onTapGesture {
                                context.delete(editingCategory!)
                                dismissSheet()
                            }
                            .alert("Unable to delete", isPresented: self.$isShowingDeletionAlert){
                                Button("OK", role: .cancel){}
                            }
                    }
                    
                    Spacer()
                    
                }.foregroundColor(colors.Primary)
                    .padding(.top, 50.0)
                
            }
            .onTapGesture {
                isFocused = false
            }
            .padding(.horizontal, 20)
        }
        
        
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        CategoryDetailsView(monthViewing: CurrentlyViewedMonth())
            .environmentObject(ColorContent())
    }
}
