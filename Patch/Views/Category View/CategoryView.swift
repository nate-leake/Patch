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
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors:ColorContent
    
    @State var dataController: DataController
    
    @ObservedObject var monthViewing: CurrentlyViewedMonth
        
    @State var isPresented = false
    @State private var editingCategory: Category?
    @State private var selectedCategory: Int? = 0
    
    var numberFormatHandler = NumberFormatHandler()
    
    init(dataController: DataController,monthViewing: CurrentlyViewedMonth){
        self.dataController = dataController
        self.monthViewing = monthViewing
    }
    
    
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
                            self.isPresented = true
                        }
                }
                
                HStack{
                    Spacer()
                    Text("Categories")
                        .font(.system(.title))
                    Spacer()
                    
                }
            }
            MonthSelectorView()
            
            ScrollView{
                
                VStack(spacing: 0){
                    if let catData = monthViewing.currentCategories {
                        ForEach(catData, id: \.id){category in
                            CategoryTileView(category: category, numberFormatHandler: numberFormatHandler)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                            
                                .onTapGesture{
                                    editingCategory = category
                                }
                        }
                    }
                    
                }
            }
            
            
        }
        
        .sheet(item: self.$editingCategory) { editCategory in
            CategoryDetailsView(monthViewing: monthViewing, category: editCategory)
                .environmentObject(colors)
        }
        
        .sheet(isPresented: self.$isPresented, onDismiss: {self.isPresented = false}){
            CategoryDetailsView(monthViewing: monthViewing)
                .environmentObject(colors)
        }
        
        
        .transition(.move(edge: .trailing))
    }
}

struct CategoryView_Previews: PreviewProvider {
    static let dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        CategoryView(dataController: dataController, monthViewing: CurrentlyViewedMonth(MOC: dataController.context))
            .environment(\.managedObjectContext, dataController.context)
            .environmentObject(ColorContent())
    }
}
