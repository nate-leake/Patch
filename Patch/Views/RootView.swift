//
//  ContentView.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

struct RootView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @EnvironmentObject var colors: ColorContent
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var monthViewing: CurrentlyViewedMonth
    @EnvironmentObject var startingBalancesStore: StartingBalanceStore
    
    @State var selectedTabs: Tabs = .home
    @State var showingMonthBalance: Bool = false
    
    func loadBalances() async {
        let m = Task{
            do {
                try await startingBalancesStore.load()
                loadList()
                return true
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        print(await m.value)
    }
    
    func loadList(){
        print(startingBalancesStore.balances)
        if startingBalancesStore.balances.isEmpty {
            print("balances empty")
            showingMonthBalance = true
        }
        else if startingBalancesStore.balances[startingBalancesStore.balances.endIndex-1].month < monthViewing.monthStart{
            print("no balance this month")
            showingMonthBalance = true
        }
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
                    CategoryView(dataController: self.dataController, monthViewing: self.monthViewing)
                case .accounts:
                    AccountsView()
                case .settings:
                    SettingsView()
                        .environmentObject(startingBalancesStore)
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
            
            GeometryReader { reader in
                LinearGradient(
                    gradient: Gradient(
                        stops:[
                            .init(color: colors.Fill.opacity(1.0), location: 0.9),
                            .init(color: Color.clear, location: 1.0)
                        ]
                    ),
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: reader.safeAreaInsets.top, alignment: .top)
                .ignoresSafeArea()
            }
        } .onAppear{
            Task {
                await loadBalances()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController(isPreviewing: true)
    
    static var previews: some View {
        RootView()
            .environmentObject(dataController)
            .environmentObject(ColorContent())
            .environment(\.managedObjectContext, dataController.context)
            .environmentObject(CurrentlyViewedMonth(MOC: dataController.context))
            .environmentObject(StartingBalanceStore())
    }
}
