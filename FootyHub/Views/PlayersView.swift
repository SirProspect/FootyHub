//
//  PlayersView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/9/26.
//

import SwiftUI
import CoreData

struct PlayersView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var dataHolder: FootyHubDataHolder

    var body: some View {
        NavigationStack {
            Group {
                if dataHolder.isLoading {
                    ProgressView("Loading players...")
                } else if dataHolder.players.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No players found")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Go to Profile and tap Seed Sample Data")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } else {
                    List(dataHolder.players) { player in
                        NavigationLink(destination: PlayerDetailView(player: player)) {
                            PlayerRowView(player: player)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Players")
            .onAppear {
                dataHolder.fetchPlayersFromFirestore(context)
            }
        }
    }
}

struct PlayerRowView: View {
    @ObservedObject var player: Player

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(player.name ?? "")
                    .font(.headline)
                    .fontWeight(.bold)

                Text(player.team ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(player.position ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(String(format: "%.1f", player.rating))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(10)
                .background(ratingColor(player.rating))
                .clipShape(Circle())
        }
        .padding(.vertical, 8)
    }

    func ratingColor(_ rating: Double) -> Color {
        if rating >= 9.0 {
            return .blue
        } else if rating >= 8.0 {
            return .orange
        } else {
            return .red
        }
    }
}
