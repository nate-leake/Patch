//
//  PatchApp.swift
//  Patch
//
//  Created by Nate Leake on 4/1/23.
//

import SwiftUI

@main
struct PatchApp: App {
    @State var dataController: DataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, dataController.context)
                .environmentObject(dataController)
                .environmentObject(ColorContent())
        }
    }
}
