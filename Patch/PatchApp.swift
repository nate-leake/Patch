//
//  PatchApp.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI
import SwiftData

@main
struct PatchApp: App {
    @StateObject var colors: ColorContent = ColorContent()
    @StateObject var startingBalancesStore: StartingBalanceStore = StartingBalanceStore()
    @StateObject var templatesStore: TemplatesStore = TemplatesStore()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(colors)
                .environmentObject(CurrentlyViewedMonth())
                .environmentObject(startingBalancesStore)
                .environmentObject(templatesStore)
        }
        .modelContainer(for: [Account.self, Category.self, Transaction.self])
        #warning("Model Container fails to load data that was stored with CoreData")
    }
}
