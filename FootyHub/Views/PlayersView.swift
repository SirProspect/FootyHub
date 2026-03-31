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
    @StateObject private var imageService = ImageService.shared
    @State private var searchText = ""
    @State private var selectedPosition = "All"

    let positions = ["All", "Forward", "Midfielder", "Defender", "Goalkeeper"]

    var filtered: [Player] {
        dataHolder.players.filter { player in
            let matchesSearch = searchText.isEmpty ||
                (player.name ?? "").localizedCaseInsensitiveContains(searchText) ||
                (player.team ?? "").localizedCaseInsensitiveContains(searchText)
            let matchesPosition = selectedPosition == "All" ||
                (player.position ?? "").localizedCaseInsensitiveContains(selectedPosition)
            return matchesSearch && matchesPosition
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(positions, id: \.self) { pos in
                            Button(action: { selectedPosition = pos }) {
                                Text(pos)
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(selectedPosition == pos ? Color.blue : Color(.tertiarySystemBackground))
                                    .foregroundColor(selectedPosition == pos ? .white : .secondary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                if dataHolder.isLoading {
                    Spacer()
                    ProgressView("Loading players...")
                    Spacer()
                } else if filtered.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "person.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No players found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filtered) { player in
                                NavigationLink(destination: PlayerDetailView(player: player)) {
                                    PlayerCardView(player: player)
                                        .onAppear {
                                            imageService.fetchPlayerImage(player.name ?? "")
                                        }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("Players")
            .searchable(text: $searchText, prompt: "Search players...")
            .onAppear { dataHolder.fetchPlayersFromFirestore(context) }
        }
    }
}

struct PlayerCardView: View {
    @ObservedObject var player: Player
    @StateObject private var imageService = ImageService.shared

    var imageURL: URL? { imageService.playerImageURL(player.name ?? "") }

    var ratingColor: Color {
        player.rating >= 9.0 ? .blue : player.rating >= 8.0 ? .green : .orange
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.indigo.opacity(0.5)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 70, height: 70)

                if let url = imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                        default:
                            Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white.opacity(0.8))
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(player.name ?? "")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)

                Text(player.team ?? "")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)

                HStack(spacing: 6) {
                    PositionBadge(position: player.position ?? "")

                    if !(player.nationality ?? "").isEmpty {
                        Text(player.nationality ?? "")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }

                HStack(spacing: 12) {
                    MiniStat(icon: "soccerball", value: "\(player.goals)", label: "G")
                    MiniStat(icon: "hands.sparkles", value: "\(player.assists)", label: "A")
                    MiniStat(icon: "calendar", value: "\(player.appearances)", label: "Apps")
                }
            }

            Spacer()

            VStack(spacing: 2) {
                ZStack {
                    Circle()
                        .stroke(ratingColor.opacity(0.25), lineWidth: 3)
                        .frame(width: 48, height: 48)
                    Circle()
                        .trim(from: 0, to: min(player.rating / 10.0, 1.0))
                        .stroke(ratingColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-90))
                    Text(String(format: "%.1f", player.rating))
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(ratingColor)
                }
                Text("Rating")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 3)
    }
}

struct PositionBadge: View {
    let position: String

    var color: Color {
        switch position.lowercased() {
        case let p where p.contains("forward"):  return .red
        case let p where p.contains("mid"):      return .blue
        case let p where p.contains("defend"):   return .green
        case let p where p.contains("goal"):     return .orange
        default: return .gray
        }
    }

    var body: some View {
        Text(position.isEmpty ? "Unknown" : position)
            .font(.system(size: 10, weight: .bold))
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

struct MiniStat: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 3) {
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.primary)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
    }
}
