//
//  Accounts View.swift
//  Patch
//
//  Created by Nate Leake on 4/4/23.
//

import SwiftUI

struct AccountsView: View {
    @EnvironmentObject var colors:ColorContent
    @Environment (\.managedObjectContext) var managedObjContext
    
    @FetchRequest(sortDescriptors: [
        //        SortDescriptor(\.title),
        SortDescriptor(\.type, order: .reverse)
    ]) var accountsData: FetchedResults<Account>
    
    @State private var selectedCategory: Int? = 0
    
    @State var showAddCategorySheet: Bool = false
    @State var showEditCategorySheet: Bool = false
    
    var numberFormatHandler = NumberFormatHandler()
    
    
    var body: some View {
        VStack{
            ZStack{
                HStack(){
                    Spacer()
                    Image(systemName: "plus.app")
                        .padding(.vertical, 2.0)
                        .padding(.horizontal, 12.0)
                        .foregroundColor(.gray)
                        .font(.system(.largeTitle))
                        .onTapGesture {
//                            showAddCategorySheet.toggle()
                        }
                }
                .sheet(isPresented: $showAddCategorySheet, content: {
                    AccountDetailsView()
                        .environmentObject(colors)
                    
                })
                
                HStack{
                    Spacer()
                    Text("Accounts")
                        .font(.system(.title))
                    Spacer()
                }
            }
            ScrollView{
                VStack{
                    ForEach(accountsData){account in
                        HStack{
                            Text(account.name ?? "Unknown")
                            Rectangle()
                                .frame(width: 1, height: 17)
                            Text("\(account.type ?? "Unknown")")
                            
                            
                        }
                        .padding()
                        .border(colors.Accent, width: 3.0)
                        .onTapGesture{
                            showEditCategorySheet.toggle()
                        }
                    }
                }
                .sheet(isPresented: $showAddCategorySheet){
                    AccountDetailsView()
                        .environmentObject(colors)
                    
                }
                
            }
        }
        Spacer()
    }
}

struct Accounts_View_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        AccountsView()
            .environmentObject(ColorContent())
            .environment(\.managedObjectContext, dataController.context)
    }
}
