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

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                VStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)

                    Text(player.name ?? "")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(player.team ?? "")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text(String(format: "%.1f", player.rating))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(16)
                        .background(ratingColor(player.rating))
                        .clipShape(Circle())
                }
                .padding(.top)

                Divider()

                VStack(spacing: 15) {
                    Text("Player Info")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    InfoRow(label: "Position", value: player.position ?? "")
                    InfoRow(label: "Nationality", value: player.nationality ?? "")
                    InfoRow(label: "Age", value: "\(player.age)")
                }
                .padding(.horizontal)

                Divider()

                VStack(spacing: 15) {
                    Text("Season Stats")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 15) {
                        StatCard(title: "Goals", value: "\(player.goals)", color: .blue)
                        StatCard(title: "Assists", value: "\(player.assists)", color: .mint)
                        StatCard(title: "Apps", value: "\(player.appearances)", color: .purple)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationTitle(player.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
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
