//
//  FootyHubApp.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/6/26.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct FootyHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthManager()
    @StateObject private var dataHolder: FootyHubDataHolder

    let persistenceController = PersistenceController.shared

    init() {
        let context = PersistenceController.shared.container.viewContext
        _dataHolder = StateObject(wrappedValue: FootyHubDataHolder(context))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authManager)
                .environmentObject(dataHolder)
        }
    }
}
