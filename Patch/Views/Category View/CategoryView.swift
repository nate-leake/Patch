//
//  CategoryView.swift
//  Patch
//
//  Created by Nate Leake on 4/4/23.
//

import SwiftUI
import CoreData

extension Int: Identifiable {
    public var id: Int { self }
}

struct CategoryView: View {
    @EnvironmentObject var colors:ColorContent
    @Environment (\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [
        //        SortDescriptor(\.title),
        SortDescriptor(\.type, order: .reverse)
    ]) var categoryData: FetchedResults<Category>
    
    @State var showAddCategorySheet: Bool = false
    @State var showEditCategorySheet: Bool = false
    
    var numberFormatHandler = NumberFormatHandler()
    
    @State private var selectedCategory: Int? = 0
    
    
    var body: some View {
        VStack{
            ZStack{
                HStack(){
                    Spacer()
                    Image(systemName: "plus.app")
                        .padding(.vertical, 2.0)
                        .padding(.horizontal, 12.0)
                        .foregroundColor(colors.Accent)
                        .font(.system(.largeTitle))
                        .onTapGesture {
                            showAddCategorySheet.toggle()
                        }
                }
                .sheet(isPresented: $showAddCategorySheet, content: {
                    CategoryDetailsView()
                        .environmentObject(colors)
                    
                })
                
                HStack{
                    Spacer()
                    Text("Categories")
                        .font(.system(.title))
                    Spacer()
                }
            }
            ScrollView{
                
                VStack(spacing: 0){
                    ForEach(categoryData){category in
                        CategoryTileView(numberFormatHandler: numberFormatHandler, category: category)
                        .padding()

                        .onTapGesture{
                            showEditCategorySheet.toggle()
                        }
                    }
                    
                }
                .sheet(isPresented: $showAddCategorySheet){
                    CategoryDetailsView()
                        .environmentObject(colors)
                    
                }
            }
            
        }
        Spacer()
    }
}

struct CategoryView_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        CategoryView()
            .environmentObject(ColorContent())
            .environment(\.managedObjectContext, dataController.context)
    }
}
