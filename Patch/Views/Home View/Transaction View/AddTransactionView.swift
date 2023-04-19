//
//  AddTransactionView.swift
//  Patch
//
//  Created by Nate Leake on 4/10/23.
//

import SwiftUI
import Combine

struct CurrencyTextField: UIViewRepresentable {
    typealias UIViewType = CurrencyUITextField
    
    let numberFormatter: NumberFormatter
    let currencyField: CurrencyUITextField
    
    
    init(numberFormatter: NumberFormatter, value: Binding<Int>) {
        self.numberFormatter = numberFormatter
        currencyField = CurrencyUITextField(formatter: numberFormatter, value: value)
    }
    
    func makeUIView(context: Context) -> CurrencyUITextField {
        return currencyField
    }
    
    func updateUIView(_ uiView: CurrencyUITextField, context: Context) { }
}


struct AddTransactionView: View {
    @EnvironmentObject var colors:ColorContent
    @Environment(\.dismiss) var dismissSheet
    
    private var numberFormatter: NumberFormatter
    
    init(numberFormatter: NumberFormatter = NumberFormatter()) {
        self.numberFormatter = numberFormatter
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2
        self.numberFormatter.maximum = 999999.99
    }
    
    @State private var dateSelected: Date = Date()
    @State private var amount: Int = 0
    @State private var description: String = ""
    @State private var categoryPicked = "Choose"
    
    
    var width: CGFloat = .infinity
    var height: CGFloat = 100
    private let  adaptiveColumns = [
        GridItem(.adaptive(minimum: .infinity))
    ]
    
    func intToCurrencyDecimal(value: Int) -> Double{
        return Double(value)/100.0
    }
    
    
    var body: some View {
        ZStack{
            colors.Fill
                .ignoresSafeArea()
            VStack{
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
                            print("Date: \(dateSelected)")
                            print("Amount: \(intToCurrencyDecimal(value: amount))")
                            print("Description: \(description)")
                            print("Category: \(categoryPicked)")
                            
                        } label: {
                            Text("Add")
                                .foregroundColor(colors.Primary)
                                .font(.system(.title3))
                            
                        }
                    }
                    .padding(.top, 25.0)
                    .padding(.bottom, 5.0)
                    
                    Text("Transaction Details")
                        .foregroundColor(colors.Primary)
                        .font(.system(.title2))
                }
                
                VStack{
                    LazyVGrid(columns: adaptiveColumns, spacing: 20){
                        
                        TransactionDetailTileView(
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
                        .frame(height: height)
                        
                        
                        TransactionDetailTileView(
                            title: "Amount",
                            content: AnyView(
                                GeometryReader{geo in
                                    CurrencyTextField(numberFormatter: numberFormatter, value: $amount)
                                        .padding(.horizontal, 20)
                                }
                            )
                        )
                        .frame(height: height)
                        
                        
                        
                        TransactionDetailTileView(
                            title: "Description",
                            content: AnyView(
                                TextField("Describe your transaction", text: $description)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                            )
                        )
                        .frame(height: height)
                        
                        
                        TransactionDetailTileView(
                            title: "Category",
                            content: AnyView(
                                Menu{
                                    Button(action: {categoryPicked = "Food"}, label: {Text("Food")})
                                    Button(action: {categoryPicked = "Gas"}, label: {Text("Gas")})
                                    Button(action: {categoryPicked = "Personal"}, label: {Text("Personal")})
                                    Button(action: {categoryPicked = "Other"}, label: {Text("Other")})
                                } label: {
                                    Label(
                                        title: {Text(categoryPicked).frame(width: 150)},
                                        icon: {}
                                    )
                                }
                                    
                            )
                        )
                        .frame(height: height)
                        
                    }
                    
                    Spacer()
                }
                .foregroundColor(colors.Primary)
                .padding(.top, 50.0)
            }.padding(.horizontal, 20.0)
        }
        
        
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
            .environmentObject(ColorContent())
    }
}
