//
//  FavoritesView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/3/26.
//

import SwiftUI
import CoreData

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published var favoriteTeamIDs:   Set<String> = []
    @Published var favoritePlayerIDs: Set<String> = []

    private let teamsKey   = "favoriteTeamIDs"
    private let playersKey = "favoritePlayerIDs"

    init() {
        let savedTeams   = UserDefaults.standard.stringArray(forKey: teamsKey)   ?? []
        let savedPlayers = UserDefaults.standard.stringArray(forKey: playersKey) ?? []
        favoriteTeamIDs   = Set(savedTeams)
        favoritePlayerIDs = Set(savedPlayers)
    }

    func toggleTeam(_ id: String) {
        if favoriteTeamIDs.contains(id) { favoriteTeamIDs.remove(id) } else { favoriteTeamIDs.insert(id) }
        UserDefaults.standard.set(Array(favoriteTeamIDs), forKey: teamsKey)
    }

    func togglePlayer(_ id: String) {
        if favoritePlayerIDs.contains(id) { favoritePlayerIDs.remove(id) } else { favoritePlayerIDs.insert(id) }
        UserDefaults.standard.set(Array(favoritePlayerIDs), forKey: playersKey)
    }

    func isTeamFavorite(_ id: String)   -> Bool { favoriteTeamIDs.contains(id) }
    func isPlayerFavorite(_ id: String) -> Bool { favoritePlayerIDs.contains(id) }
}

// MARK: - Favorites View
struct FavoritesView: View {
    @EnvironmentObject var dataHolder: FootyHubDataHolder
    @ObservedObject var favorites = FavoritesManager.shared

    var favoriteTeams: [Team] {
        dataHolder.teams.filter { team in
            guard let id = team.id?.uuidString else { return false }
            return favorites.isTeamFavorite(id)
        }
    }

    var favoritePlayers: [Player] {
        dataHolder.players.filter { player in
            guard let id = player.id?.uuidString else { return false }
            return favorites.isPlayerFavorite(id)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoriteTeams.isEmpty && favoritePlayers.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No Favorites Yet")
                            .font(.title2).fontWeight(.bold)
                        Text("Tap the heart icon on any team or player to add them here.")
                            .font(.subheadline).foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    List {
                        if !favoriteTeams.isEmpty {
                            Section(header: Text("⭐ Favorite Teams")) {
                                ForEach(favoriteTeams, id: \.id) { team in
                                    NavigationLink(destination: TeamDetailView(team: team)) {
                                        HStack {
                                            Image(systemName: "shield.fill").foregroundColor(.blue).frame(width: 30)
                                            VStack(alignment: .leading) {
                                                Text(team.name ?? "").fontWeight(.semibold)
                                                Text(team.league ?? "").font(.caption).foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                                .onDelete { indexSet in
                                    for i in indexSet {
                                        if let id = favoriteTeams[i].id?.uuidString { favorites.toggleTeam(id) }
                                    }
                                }
                            }
                        }

                        if !favoritePlayers.isEmpty {
                            Section(header: Text("⭐ Favorite Players")) {
                                ForEach(favoritePlayers, id: \.id) { player in
                                    NavigationLink(destination: PlayerDetailView(player: player)) {
                                        HStack {
                                            Image(systemName: "person.circle.fill").foregroundColor(.blue).frame(width: 30)
                                            VStack(alignment: .leading) {
                                                Text(player.name ?? "").fontWeight(.semibold)
                                                Text(player.team ?? "").font(.caption).foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Text(String(format: "%.1f", player.rating))
                                                .font(.caption).fontWeight(.bold).foregroundColor(.white)
                                                .padding(6).background(Color.blue).clipShape(Circle())
                                        }
                                    }
                                }
                                .onDelete { indexSet in
                                    for i in indexSet {
                                        if let id = favoritePlayers[i].id?.uuidString { favorites.togglePlayer(id) }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

// MARK: - Reusable Favorite Button
struct FavoriteButton: View {
    let id: String
    let type: FavoriteType
    @ObservedObject var favorites = FavoritesManager.shared

    enum FavoriteType { case team, player }

    var isFavorite: Bool {
        type == .team ? favorites.isTeamFavorite(id) : favorites.isPlayerFavorite(id)
    }

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                if type == .team { favorites.toggleTeam(id) } else { favorites.togglePlayer(id) }
            }
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .gray)
                .font(.title3)
        }
    }
}
