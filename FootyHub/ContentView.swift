//
//  ContentView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/6/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        if authManager.isSignedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}
