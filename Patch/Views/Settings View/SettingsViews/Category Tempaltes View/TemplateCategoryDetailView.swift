//
//  TemplateCategoryDetailView.swift
//  Patch
//
//  Created by Nate Leake on 7/18/23.
//

import SwiftUI

struct TemplateCategoryDetailView: View {
    @Environment(\.dismiss) var dismissSheet
    @EnvironmentObject var colors : ColorContent
    @EnvironmentObject var templatesStore: TemplatesStore
    
    @FocusState private var isFocused: Bool
    
    @State var submitText: String = "Add"
    
    
    @State var name: String = ""
    @State var limitAmount: Int = 0
    @State var typeSelection: String = "Expense"
    @State var sfCategory: SFCategory = .food
    @State private var icon = "questionmark"
    
    @State var isShowingNameValidation = false
    @State var isShowingLimitValidation = false
    @State var isShowingTypeValidation = false
    
    @State var isShowingDeletionAlert = false
    
    let categoryTypeOptions = ["Income", "Expense"]
    
    var editingCategory: TemplateCategory?
    var isEditing = false
    
    let saveAction: ()->Void
    
    init(saveAction: @escaping ()->Void, category: TemplateCategory? = nil){
        self.saveAction = saveAction
        if let tc = category {
            self.editingCategory = tc
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
        if !isEditing {
            let toAdd = TemplateCategory(name: name, type: typeSelection, limit: limitAmount, symbol: icon)
            templatesStore.templates[0].categories.append(toAdd)
        } else {
            let index = templatesStore.templates[0].categories.firstIndex(of: editingCategory!)
            if let i = index {
                templatesStore.templates[0].categories[i].name = name
                templatesStore.templates[0].categories[i].type = typeSelection
                templatesStore.templates[0].categories[i].limit = limitAmount
                templatesStore.templates[0].categories[i].symbol = icon
            }
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
            saveAction()
        }
        
        return returnState
    }
    
    var body: some View {
        ZStack{
            colors.Fill.ignoresSafeArea()
            VStack{
                CustomSheetHeaderView(sheetTitle: "Template Category Details", submitText: self.submitText, validateFeilds: validateInputs)
                
                VStack{
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 20){
                        if isShowingNameValidation{
                            Text("A name is required")
                                .foregroundColor(.red)
                        }
                        DetailTileView(
                            title: "Name",
                            content: AnyView(
                                TextField("Name this category", text: $name)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(colors.InputText)
                            )
                        )
                        
                        if isShowingLimitValidation{
                            Text("Amount cannot be zero")
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
                                self.name = self.editingCategory?.name ?? ""
                                self.limitAmount = Int(self.editingCategory?.limit ?? 000)
                                self.typeSelection = self.editingCategory?.type ?? "Expense"
                                self.submitText = "Save"
                                self.icon = self.editingCategory?.symbol ?? "nosign"
                                
                                print("category: "+self.name)
                                print("\(self.limitAmount)")
                            }
                        }
                    )
                    if isEditing {
                        Spacer()
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.system(.title))
                            .onTapGesture {
                                let index = templatesStore.templates[0].categories.firstIndex(of: self.editingCategory!)
                                if let i = index {
                                    templatesStore.templates[0].categories.remove(at: i)
                                    saveAction()
                                    dismissSheet()
                                } else {
                                    isShowingDeletionAlert = true
                                }
                                
                            }
                            .alert("Unable to delete", isPresented: self.$isShowingDeletionAlert){
                                Button("OK", role: .cancel){}
                            }
                    }
                    Spacer()
                }
                .padding(.top, 50.0)
            }
            .onTapGesture {
                isFocused = false
            }
            .padding(.horizontal, 20)
        }
    }
}

struct TemplateCategoryDetailView_Previews: PreviewProvider {
    static var startingBalancesStore = StartingBalanceStore()
    
    static var previews: some View {
        TemplateCategoryDetailView()
        {
            Task {
                do {
                    try await startingBalancesStore.save(balances: startingBalancesStore.balances)
                }
                catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
