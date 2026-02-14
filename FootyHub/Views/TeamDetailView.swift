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

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                VStack(spacing: 10) {
                    Image(systemName: "shield.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)

                    Text(team.name ?? "")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(team.league ?? "")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

                Divider()

                VStack(spacing: 15) {
                    Text("Team Info")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    InfoRow(label: "Country", value: team.country ?? "")
                    InfoRow(label: "Founded", value: "\(team.founded)")
                    InfoRow(label: "Stadium", value: team.stadium ?? "")
                }
                .padding(.horizontal)

                Divider()

                VStack(spacing: 15) {
                    Text("Season Stats")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 15) {
                        StatCard(title: "Wins", value: "\(team.wins)", color: .blue)
                        StatCard(title: "Draws", value: "\(team.draws)", color: .orange)
                        StatCard(title: "Losses", value: "\(team.losses)", color: .red)
                    }

                    HStack(spacing: 15) {
                        StatCard(title: "Goals For", value: "\(team.goalsScored)", color: .mint)
                        StatCard(title: "Goals Against", value: "\(team.goalsConceded)", color: .purple)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationTitle(team.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
