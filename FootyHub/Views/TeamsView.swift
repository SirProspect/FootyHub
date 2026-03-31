//
//  TeamsView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/9/26.
//

import SwiftUI
import CoreData

struct TeamsView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var dataHolder: FootyHubDataHolder
    @StateObject private var imageService = ImageService.shared
    @State private var searchText = ""

    var filtered: [Team] {
        if searchText.isEmpty { return dataHolder.teams }
        return dataHolder.teams.filter {
            ($0.name ?? "").localizedCaseInsensitiveContains(searchText) ||
            ($0.league ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                if dataHolder.isLoading {
                    ProgressView("Loading teams...")
                        .padding(.top, 60)
                } else if dataHolder.teams.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "shield.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("No teams found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Go to Profile → Seed Sample Data")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 80)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filtered) { team in
                            NavigationLink(destination: TeamDetailView(team: team)) {
                                TeamCardView(team: team)
                                    .onAppear {
                                        imageService.fetchTeamImage(team.name ?? "")
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Teams")
            .searchable(text: $searchText, prompt: "Search teams...")
            .onAppear { dataHolder.fetchTeamsFromFirestore(context) }
        }
    }
}

struct TeamCardView: View {
    @ObservedObject var team: Team
    @StateObject private var imageService = ImageService.shared

    var imageURL: URL? { imageService.teamImageURL(team.name ?? "") }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.7), Color.indigo.opacity(0.9)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 130)

                if let url = imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .shadow(color: .black.opacity(0.3), radius: 8)
                        default:
                            Image(systemName: "shield.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                } else {
                    Image(systemName: "shield.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            VStack(spacing: 6) {
                Text(team.name ?? "")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text(team.league ?? "")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Divider().padding(.horizontal, 8)

                HStack(spacing: 0) {
                    StatPill(label: "W", value: "\(team.wins)", color: .green)
                    StatPill(label: "D", value: "\(team.draws)", color: .orange)
                    StatPill(label: "L", value: "\(team.losses)", color: .red)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}

struct StatPill: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
