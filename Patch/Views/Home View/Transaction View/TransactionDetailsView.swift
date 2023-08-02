//
//  AddTransactionView.swift
//  Patch
//
//  Created by Nate Leake on 4/10/23.
//

import SwiftUI
import SwiftData

struct TransactionDetailsView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismissSheet
    @EnvironmentObject var colors: ColorContent
    
    @ObservedObject var monthViewing: CurrentlyViewedMonth
    
    @FocusState private var isFocused: Bool
    
    @Query private var accountData: [Account]
    @Query private var categoryData: [Category]
    
    @State private var amount: Int = 0
    @State private var categoryPicked: Category?
    @State private var dateSelected: Date = Date()
    @State private var description: String = ""
    @State private var submitText = "Add"
    
    private let adaptiveColumns = [ GridItem(.adaptive(minimum: .infinity)) ]
    
    var editingTransaction: Transaction?
    var isEditing: Bool = false
    var height: CGFloat = 100
    var numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    var width: CGFloat = .infinity
    
    @State var isShowingAmountValidation: Bool = false
    @State var isShowingCategoryValidation: Bool = false
    
    
    init(monthViewing: CurrentlyViewedMonth, transaction: Transaction? = nil){
        self.monthViewing = monthViewing
        print("Editing transaction: \(String(describing: transaction))")
        if let t = transaction {
            self.editingTransaction = t
            self.isEditing = true
            return
        }
    }
    
    func addTransaction(){
        if isEditing {
            editingTransaction?.edit(amount: amount, date: dateSelected, memo: description, category: categoryPicked!)
            try? context.save()
        } else {
            // create item
            let item = Transaction(amount: amount, date: dateSelected, memo: description, category: categoryPicked)
            // add item to data context
            context.insert(item)
        }
    }
    
    
    func validateInputs() -> Bool{
        var returnState = true
        
        self.isShowingAmountValidation = false
        self.isShowingCategoryValidation = false
        
        
        if categoryPicked == nil {
            self.isShowingCategoryValidation = true
            returnState = false
        }
        
        if (amount == 0){
            self.isShowingAmountValidation = true
            returnState = false
        }
        
        if returnState == true{
            self.addTransaction()
        }
        
        return returnState
    }
    
    var body: some View {
        ZStack{
            colors.Fill.ignoresSafeArea()
            VStack{
                CustomSheetHeaderView(sheetTitle: "Transaction Details", submitText: self.submitText, validateFeilds: validateInputs)
                LazyVGrid(columns: adaptiveColumns, spacing: 20){
                    DetailTileView(
                        title: "Date",
                        content: AnyView(
                            VStack{
                                DatePicker("",
                                           selection: $dateSelected,
                                           displayedComponents: [.date, .hourAndMinute]
                                )
                                .tint(colors.Accent)
                                .labelsHidden()
                                .datePickerStyle(.automatic)
                                
                            }
                        )
                    )
                    
                    if isShowingAmountValidation{
                        Text("Amount cannot be zero")
                            .foregroundColor(.red)
                    }
                    
                    DetailTileView(
                        title: "Amount",
                        content: AnyView(
                            CurrencyField(value: $amount)
                                .padding(.horizontal, 20)
                                .foregroundColor(colors.InputText)
                                .font(.system(.title2))
                                .focused($isFocused)
                        )
                    )
                    
                    DetailTileView(
                        title: "Description",
                        content: AnyView(
                            TextField("Describe your transaction", text: $description)
                                .tint(colors.Primary)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center)
                                .foregroundColor(colors.InputText)
                        )
                    )
                    
                    
                    if isShowingCategoryValidation {
                        Text("Select a category")
                            .foregroundColor(.red)
                    }
                    DetailTileView(
                        title: "Category",
                        content: AnyView(
                            Menu{
                                ForEach(categoryData ){category in
                                    Button(category.title!){
                                        categoryPicked = category
                                    }
                                }
                            } label: {
                                Label(
                                    title: {Text(categoryPicked?.title! ?? "Choose").frame(width: 150)},
                                    icon: {}
                                )
                            }
                                .foregroundColor(colors.InputSelect)
                            
                        )
                    )
                    
                }
                .padding(.top, 50.0)
                .onAppear(
                    perform: {
                        if self.isEditing{
                            self.dateSelected = self.editingTransaction?.date ?? Date()
                            self.amount = Int(self.editingTransaction?.amount ?? 100)
                            self.description = self.editingTransaction?.memo ?? ""
                            self.categoryPicked = self.editingTransaction?.category
                            self.submitText = "Save"
                        }
                    }
                )
                
                if isEditing {
                    Spacer()
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.system(.title))
                        .onTapGesture {
                            context.delete(editingTransaction!)
                            dismissSheet()
                        }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onTapGesture {
            isFocused = false
        }
        
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    
    static var previews: some View {
        TransactionDetailsView(monthViewing: CurrentlyViewedMonth())
            .environmentObject(ColorContent())
        
    }
}
