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

    var body: some View {
        NavigationStack {
            Group {
                if dataHolder.isLoading {
                    ProgressView("Loading teams...")
                } else if dataHolder.teams.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "shield.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No teams found")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Go to Profile and tap Seed Sample Data")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } else {
                    List(dataHolder.teams) { team in
                        NavigationLink(destination: TeamDetailView(team: team)) {
                            TeamRowView(team: team)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Teams")
            .onAppear {
                dataHolder.fetchTeamsFromFirestore(context)
            }
        }
    }
}

struct TeamRowView: View {
    @ObservedObject var team: Team

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "shield.fill")
                .font(.system(size: 35))
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(team.name ?? "")
                    .font(.headline)
                    .fontWeight(.bold)

                Text(team.league ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(team.country ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("W: \(team.wins)")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("D: \(team.draws)")
                    .font(.caption)
                    .foregroundColor(.orange)
                Text("L: \(team.losses)")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}
