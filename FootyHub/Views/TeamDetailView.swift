//
//  TeamDetailView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/9/26.
//

import SwiftUI
import CoreData

struct TeamDetailView: View {
    @ObservedObject var team: Team
    @StateObject private var imageService = ImageService.shared

    var imageURL: URL? { imageService.teamImageURL(team.name ?? "") }
    var totalGames: Int32 { team.wins + team.draws + team.losses }
    var winRate: Double {
        totalGames > 0 ? Double(team.wins) / Double(totalGames) : 0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                ZStack(alignment: .bottom) {
                    LinearGradient(
                        colors: [Color.blue.opacity(0.85), Color.indigo, Color.black.opacity(0.95)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 260)

                    VStack(spacing: 12) {
                        if let url = imageURL {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let img):
                                    img.resizable()
                                        .scaledToFit()
                                        .frame(width: 110, height: 110)
                                        .shadow(color: .black.opacity(0.4), radius: 12)
                                default:
                                    Image(systemName: "shield.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        } else {
                            Image(systemName: "shield.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.7))
                                .onAppear { imageService.fetchTeamImage(team.name ?? "") }
                        }

                        Text(team.name ?? "")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        HStack(spacing: 8) {
                            Label(team.league ?? "", systemImage: "trophy.fill")
                            Text("•")
                            Label(team.country ?? "", systemImage: "flag.fill")
                        }
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 24)
                }

                VStack(spacing: 16) {

                    HStack(spacing: 12) {
                        BigStatCard(title: "Wins",   value: "\(team.wins)",   color: .green,  icon: "checkmark.circle.fill")
                        BigStatCard(title: "Draws",  value: "\(team.draws)",  color: .orange, icon: "equal.circle.fill")
                        BigStatCard(title: "Losses", value: "\(team.losses)", color: .red,    icon: "xmark.circle.fill")
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    GlassCard {
                        VStack(spacing: 10) {
                            HStack {
                                Text("Win Rate")
                                    .font(.system(size: 15, weight: .semibold))
                                Spacer()
                                Text(String(format: "%.0f%%", winRate * 100))
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.green)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 10)
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: geo.size.width * winRate, height: 10)
                                }
                            }
                            .frame(height: 10)
                        }
                    }
                    .padding(.horizontal)

                    GlassCard {
                        HStack {
                            VStack(spacing: 4) {
                                Text("\(team.goalsScored)")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.blue)
                                Text("Goals For")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)

                            Divider().frame(height: 40)

                            VStack(spacing: 4) {
                                Text("\(team.goalsConceded)")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.red)
                                Text("Goals Against")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)

                            Divider().frame(height: 40)

                            VStack(spacing: 4) {
                                let diff = Int(team.goalsScored) - Int(team.goalsConceded)
                                Text(diff >= 0 ? "+\(diff)" : "\(diff)")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(diff >= 0 ? .green : .red)
                                Text("Goal Diff")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)

                    GlassCard {
                        VStack(spacing: 12) {
                            Text("Club Info")
                                .font(.system(size: 15, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            InfoRow(label: "Founded", value: "\(team.founded)")
                            InfoRow(label: "Stadium", value: team.stadium ?? "")
                            InfoRow(label: "Country",  value: team.country ?? "")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let id = team.id?.uuidString {
                    FavoriteButton(id: id, type: .team)
                }
            }
        }
    }
}

struct GlassCard<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

struct BigStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.1))
        .cornerRadius(14)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .font(.system(size: 14))
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .font(.system(size: 14))
                .multilineTextAlignment(.trailing)
        }
    }
}
