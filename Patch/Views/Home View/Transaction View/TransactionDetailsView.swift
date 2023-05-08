//
//  AddTransactionView.swift
//  Patch
//
//  Created by Nate Leake on 4/10/23.
//

import SwiftUI

struct TransactionDetailsView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var colors: ColorContent
    
    @Environment(\.dismiss) var dismissSheet
    @FetchRequest(sortDescriptors: [SortDescriptor(\.type)]) var categoryData: FetchedResults<Category>
    
    var numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    var editingTransaction: Transaction?
    var isEditing: Bool = false
        
    @State private var dateSelected: Date = Date()
    @State private var amount: Int = 0
    @State private var description: String = ""
    @State private var categoryPicked: Category?
    
    @State private var submitText = "Add"
    
    var width: CGFloat = .infinity
    var height: CGFloat = 100
    private let  adaptiveColumns = [
        GridItem(.adaptive(minimum: .infinity))
    ]
    
    init(transaction: Transaction? = nil){
        print("Editing transaction: \(String(describing: transaction))")
        if let t = transaction {
            self.editingTransaction = t
            self.isEditing = true
            return
        }
    }
    
    
    func validateInputs() -> Bool{
        guard categoryPicked != nil else {
            return false
        }
        if (amount != 0){
            if isEditing {
                dataController.editTransaction(
                    transaction: editingTransaction!, category: categoryPicked!, date: dateSelected, amount: amount, memo: description
                )
            } else {
                dataController.addTransaction(category: categoryPicked!, date: dateSelected, amount: amount, memo: description)
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
                CustomSheetHeaderView(validateFeilds: validateInputs, sheetTitle: "Transaction Details", submitText: self.submitText)
                LazyVGrid(columns: adaptiveColumns, spacing: 20){
                    DetailTileView(
                        title: "Date",
                        content: AnyView(
                            VStack{
                                DatePicker("",
                                           selection: $dateSelected,
                                           displayedComponents: [.date, .hourAndMinute]
                                )
                                .labelsHidden()
                                .datePickerStyle(.automatic)
                                
                            }
                        )
                    )
                    
                    DetailTileView(
                        title: "Amount",
                        content: AnyView(
                            CurrencyField(value: $amount)
                                .padding(.horizontal, 20)
                                .foregroundColor(colors.InputText)
                                .font(.system(.title2))
                        )
                    )
                    
                    DetailTileView(
                        title: "Description",
                        content: AnyView(
                            TextField("Describe your transaction", text: $description)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center)
                                .foregroundColor(colors.InputText)
                        )
                    )
                    
                    
                    DetailTileView(
                        title: "Category",
                        content: AnyView(
                            Menu{
                                ForEach(categoryData){category in
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
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        TransactionDetailsView()
            .environment(\.managedObjectContext, dataController.context)
            .environmentObject(ColorContent())
        
    }
}
