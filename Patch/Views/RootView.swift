//
//  ContentView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var monthViewing: CurrentlyViewedMonth
    @EnvironmentObject var startingBalancesStore: StartingBalanceStore
    @EnvironmentObject var templatesStore: TemplatesStore
    
    @Query private var accountData: [Account]
    @Query private var categoryData: [Category]
    
    @State var selectedTabs: Tabs = .home
    @State var showingMonthBalance: Bool = false
    
    func loadBalances() async {
        let m = Task{
            do {
                try await startingBalancesStore.load()
                checkPresentBalanceSheet()
                return true
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        print(await m.value)
    }
    
    func loadCategoryTempaltes() async {
        let t = Task {
            do {
                try await templatesStore.load()
                checkAutoApplyCategoryTemplate()
                return true
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        print(await t.value)
    }
    
    func checkPresentBalanceSheet(){
        if startingBalancesStore.balances.isEmpty {
            showingMonthBalance = true
        }
        else if startingBalancesStore.balances[startingBalancesStore.balances.endIndex-1].month < monthViewing.monthStart{
            showingMonthBalance = true
        }
    }
    
    func checkAutoApplyCategoryTemplate(){
        if categoryData.isEmpty {
            for cat in templatesStore.templates[0].categories{
                let item = Category(date: monthViewing.monthStart, limit: cat.limit, symbolName: cat.symbol, title: cat.name, type: cat.type, account: accountData[0])
                context.insert(item)
            }
        }
        print(accountData)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            colors.Fill
                .ignoresSafeArea()
            VStack(spacing:0){
                switch selectedTabs {
                case .home:
                    HomeView()
                case .categories:
                    CategoryView(monthViewing: self.monthViewing)
                case .accounts:
                    AccountsView()
                case .settings:
                    SettingsView()
                        .environmentObject(startingBalancesStore)
                        .environmentObject(templatesStore)
                }
                
                CustomTabBar(selectedTab: $selectedTabs)
            }
            .sheet(isPresented: $showingMonthBalance){
                StartingBalanceSheetView()
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
                .environmentObject(startingBalancesStore)
            }
            
//            GeometryReader { reader in
//                LinearGradient(
//                    gradient: Gradient(
//                        stops:[
//                            .init(color: colors.Fill.opacity(1.0), location: 0.9),
//                            .init(color: Color.clear, location: 1.0)
//                        ]
//                    ),
//                    startPoint: .top, endPoint: .bottom
//                )
//                .frame(height: reader.safeAreaInsets.top, alignment: .top)
//                .ignoresSafeArea()
//            }
            
        } .onAppear{
            Task {
                await loadBalances()
                await loadCategoryTempaltes()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView()
            .environmentObject(ColorContent())
            .environmentObject(CurrentlyViewedMonth())
            .environmentObject(StartingBalanceStore())
    }
}
