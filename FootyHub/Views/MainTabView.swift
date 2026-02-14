//
//  MainTabView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/8/26.
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            TeamsView()
                .tabItem {
                    Image(systemName: "shield.fill")
                    Text("Teams")
                }

            PlayersView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Players")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .accentColor(.blue)
    }
}
