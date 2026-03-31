//
//  LeagueDetailView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/20/26.
//

import SwiftUI

struct LeagueDetailView: View {
    let league: LeagueStandingData

    private var seasonLabel: String { "2025/26 season" }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                ZStack {
                    LinearGradient(
                        colors: [Color.blue.opacity(0.8), Color.indigo.opacity(0.95)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 160)

                    VStack(spacing: 6) {
                        Text(league.flag)
                            .font(.system(size: 48))
                        Text(league.leagueName)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        Text(league.country)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                        Text(seasonLabel)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.65))
                    }
                }

                HStack(spacing: 16) {
                    LegendItem(color: .yellow, label: "Champion")
                    LegendItem(color: .blue,   label: "UCL")
                    LegendItem(color: .orange,  label: "UEL")
                }
                .padding(.horizontal)

                VStack(spacing: 0) {
                    HStack {
                        Text("#").frame(width: 24, alignment: .center)
                        Text("Team").frame(maxWidth: .infinity, alignment: .leading)
                        Text("P").frame(width: 26, alignment: .center)
                        Text("W").frame(width: 26, alignment: .center)
                        Text("D").frame(width: 26, alignment: .center)
                        Text("L").frame(width: 26, alignment: .center)
                        Text("GD").frame(width: 32, alignment: .center)
                        Text("Pts").frame(width: 36, alignment: .center)
                    }
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))

                    ForEach(league.standings) { row in
                        StandingRowView(row: row)
                        Divider().padding(.leading, 16)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.06), radius: 6)
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle(league.leagueName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LegendItem: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color.opacity(0.3))
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(color, lineWidth: 1.5))
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
}
