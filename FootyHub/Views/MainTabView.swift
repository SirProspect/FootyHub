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

            LiveScoresView()
                .tabItem {
                    Image(systemName: "dot.radiowaves.left.and.right")
                    Text("Live")
                }

            StandingsView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("Standings")
                }

            StadiumMapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Stadiums")
                }

            MoreView()
                .tabItem {
                    Image(systemName: "ellipsis.circle.fill")
                    Text("More")
                }
        }
        .accentColor(.blue)
    }
}

struct MoreView: View {
    private var headerDate: String {
        Date.now.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day().year())
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("FootyHub")
                            .font(.headline)
                        Text(headerDate)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section {
                    NavigationLink(destination: TopScorersView()) {
                        Label("Top Scorers", systemImage: "trophy.fill")
                    }
                    NavigationLink(destination: NewsView()) {
                        Label("News",        systemImage: "newspaper.fill")
                    }
                    NavigationLink(destination: FavoritesView()) {
                        Label("Favorites",   systemImage: "heart.fill")
                    }
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings",    systemImage: "gearshape.fill")
                    }
                    NavigationLink(destination: ProfileView()) {
                        Label("Profile",     systemImage: "person.circle.fill")
                    }
                }
            }
            .navigationTitle("More")
        }
    }
}
