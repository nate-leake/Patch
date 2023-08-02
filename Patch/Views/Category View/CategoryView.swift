//
//  CategoryView.swift
//  Patch
//
//  Created by Nate Leake on 4/4/23.
//

import SwiftUI
import SwiftData

extension Int: Identifiable {
    public var id: Int { self }
}

struct CategoryView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors:ColorContent
        
    @ObservedObject var monthViewing: CurrentlyViewedMonth
    @Query private var categories: [Category]
    
    @State var isPresented = false
    @State private var editingCategory: Category?
    @State private var selectedCategory: Int? = 0
    
    var numberFormatHandler = NumberFormatHandler()
    
    init(monthViewing: CurrentlyViewedMonth){
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
                    ForEach(categories, id: \.id){category in
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
    
    static var previews: some View {
        CategoryView(monthViewing: CurrentlyViewedMonth())
            .environmentObject(ColorContent())
    }
}
