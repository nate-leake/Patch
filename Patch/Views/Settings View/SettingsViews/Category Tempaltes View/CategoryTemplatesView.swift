//
//  CategoryTemplates.swift
//  Patch
//
//  Created by Nate Leake on 7/17/23.
//

import SwiftUI

struct CategoryTemplatesView: View {
    @EnvironmentObject var colors : ColorContent
    @EnvironmentObject var templatesStore: TemplatesStore
    
    @State var isPresented = false
    @State private var editingCategory: TemplateCategory?
    
    var numberFormatHandler: NumberFormatHandler = NumberFormatHandler()
    
    var body: some View {
        NavigationLink{
            ZStack{
                colors.Fill
                    .ignoresSafeArea()
                NavigationStack{
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
                        }
                        
                        ScrollView{
                            
                            VStack(spacing: 0){
                                
                                ForEach($templatesStore.templates[0].categories, id: \.id){ category in
                                    TemplateCategoryView(category: category.wrappedValue)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal)
                                    
                                        .onTapGesture{
                                            editingCategory = category.wrappedValue
                                        }
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                    .sheet(item: self.$editingCategory) { editCategory in
                        TemplateCategoryDetailView(saveAction: {
                            Task {
                                do { try await templatesStore.save(templates: templatesStore.templates) }
                                catch { fatalError(error.localizedDescription) }
                            }
                        },
                                                   category: editCategory)
                        .environmentObject(colors)
                    }
                    
                    .sheet(isPresented: self.$isPresented, onDismiss: {self.isPresented = false}){
                        TemplateCategoryDetailView()
                        {
                            Task {
                                do {
                                    try await templatesStore.save(templates: templatesStore.templates)
                                }
                                catch {
                                    fatalError(error.localizedDescription)
                                }
                            }
                            
                        }
                        .environmentObject(colors)
                        
                        .transition(.move(edge: .trailing))
                        
                    }
                }
                .navigationTitle("Category Template")
                
            }
        } label: {
            Text("Category Template")
        }
    }
}

struct CategoryTemplatesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTemplatesView()
            .environmentObject(ColorContent())
            .environmentObject(TemplatesStore())
    }
}
