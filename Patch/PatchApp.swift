//
//  PatchApp.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

@main
struct PatchApp: App {
    @StateObject var colors: ColorContent = ColorContent()
    @StateObject var dataController: DataController = DataController()
    @StateObject var startingBalancesStore: StartingBalanceStore = StartingBalanceStore()
    @StateObject var templatesStore: TemplatesStore = TemplatesStore()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, dataController.context)
                .environmentObject(colors)
                .environmentObject(dataController)
                .environmentObject(CurrentlyViewedMonth(MOC: dataController.context))
                .environmentObject(startingBalancesStore)
                .environmentObject(templatesStore)
        }
    }
}
