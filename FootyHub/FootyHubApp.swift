//
//  FootyHubApp.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/9/26.
//

import SwiftUI

@main
struct FootyHubApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
