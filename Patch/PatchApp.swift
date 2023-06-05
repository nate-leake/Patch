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
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, dataController.context)
                .environmentObject(colors)
                .environmentObject(dataController)
                .environmentObject(CurrentlyViewedMonth(MOC: dataController.context))
        }
    }
}
