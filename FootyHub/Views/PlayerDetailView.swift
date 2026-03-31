//
//  PlayerDetailView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/9/26.
//

import SwiftUI
import CoreData

struct PlayerDetailView: View {
    @ObservedObject var player: Player
    @StateObject private var imageService = ImageService.shared

    var imageURL: URL? { imageService.playerImageURL(player.name ?? "") }

    var ratingColor: Color {
        player.rating >= 9.0 ? .blue : player.rating >= 8.0 ? .green : .orange
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                ZStack(alignment: .bottom) {
                    LinearGradient(
                        colors: [ratingColor.opacity(0.7), Color.black.opacity(0.95)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 300)

                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 120, height: 120)

                            if let url = imageURL {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let img):
                                        img.resizable()
                                            .scaledToFill()
                                            .frame(width: 115, height: 115)
                                            .clipShape(Circle())
                                            .shadow(color: .black.opacity(0.5), radius: 12)
                                    default:
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 55))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 55))
                                    .foregroundColor(.white.opacity(0.7))
                                    .onAppear { imageService.fetchPlayerImage(player.name ?? "") }
                            }
                        }

                        Text(player.name ?? "")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)

                        HStack(spacing: 10) {
                            PositionBadge(position: player.position ?? "")
                            Text(player.team ?? "")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.8))
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(ratingColor)
                                .font(.system(size: 14))
                            Text(String(format: "%.1f", player.rating))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(ratingColor)
                            Text("Overall")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(ratingColor.opacity(0.2))
                        .cornerRadius(20)
                    }
                    .padding(.bottom, 24)
                }

                VStack(spacing: 16) {

                    HStack(spacing: 12) {
                        BigStatCard(title: "Goals",   value: "\(player.goals)",       color: .blue,   icon: "soccerball.circle.fill")
                        BigStatCard(title: "Assists",  value: "\(player.assists)",     color: .mint,   icon: "hands.sparkles.fill")
                        BigStatCard(title: "Apps",     value: "\(player.appearances)", color: .purple, icon: "calendar.circle.fill")
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    GlassCard {
                        VStack(spacing: 10) {
                            HStack {
                                Text("Player Rating")
                                    .font(.system(size: 15, weight: .semibold))
                                Spacer()
                                Text(String(format: "%.1f / 10", player.rating))
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(ratingColor)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 10)
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(LinearGradient(
                                            colors: [ratingColor.opacity(0.7), ratingColor],
                                            startPoint: .leading, endPoint: .trailing
                                        ))
                                        .frame(width: geo.size.width * min(player.rating / 10.0, 1.0), height: 10)
                                }
                            }
                            .frame(height: 10)
                        }
                    }
                    .padding(.horizontal)

                    GlassCard {
                        VStack(spacing: 12) {
                            Text("Player Info")
                                .font(.system(size: 15, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            InfoRow(label: "Nationality", value: player.nationality ?? "")
                            InfoRow(label: "Age",         value: "\(player.age) years")
                            InfoRow(label: "Position",    value: player.position ?? "")
                            InfoRow(label: "Club",        value: player.team ?? "")
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
                if let id = player.id?.uuidString {
                    FavoriteButton(id: id, type: .player)
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2).fontWeight(.bold).foregroundColor(color)
            Text(title)
                .font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
