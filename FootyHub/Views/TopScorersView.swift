//
//  TopScorersView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/22/26.
//

import SwiftUI
import UIKit

struct TopScorer: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let team: String
    let nationality: String
    let goals: Int
    let assists: Int
    let appearances: Int
    let league: String
}

let sampleTopScorers: [TopScorer] = [
    TopScorer(rank: 1,  name: "Erling Haaland",     team: "Manchester City",    nationality: "🇳🇴", goals: 32, assists: 6,  appearances: 30, league: "Premier League"),
    TopScorer(rank: 2,  name: "Harry Kane",          team: "Bayern Munich",      nationality: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", goals: 30, assists: 8,  appearances: 32, league: "Bundesliga"),
    TopScorer(rank: 3,  name: "Kylian Mbappé",       team: "Real Madrid",        nationality: "🇫🇷", goals: 28, assists: 10, appearances: 32, league: "La Liga"),
    TopScorer(rank: 4,  name: "Victor Osimhen",      team: "Napoli",             nationality: "🇳🇬", goals: 25, assists: 5,  appearances: 28, league: "Serie A"),
    TopScorer(rank: 5,  name: "Robert Lewandowski",  team: "FC Barcelona",       nationality: "🇵🇱", goals: 24, assists: 7,  appearances: 30, league: "La Liga"),
    TopScorer(rank: 6,  name: "Paris Saint-Germain", team: "PSG",                nationality: "🇫🇷", goals: 23, assists: 3,  appearances: 28, league: "Ligue 1"),
    TopScorer(rank: 7,  name: "Mohamed Salah",       team: "Liverpool",          nationality: "🇪🇬", goals: 22, assists: 12, appearances: 30, league: "Premier League"),
    TopScorer(rank: 8,  name: "Vinícius Jr",         team: "Real Madrid",        nationality: "🇧🇷", goals: 20, assists: 14, appearances: 30, league: "La Liga"),
    TopScorer(rank: 9,  name: "Bukayo Saka",         team: "Arsenal",            nationality: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", goals: 16, assists: 14, appearances: 28, league: "Premier League"),
    TopScorer(rank: 10, name: "Jamal Musiala",       team: "Bayern Munich",      nationality: "🇩🇪", goals: 15, assists: 12, appearances: 30, league: "Bundesliga"),
    TopScorer(rank: 11, name: "Jude Bellingham",     team: "Real Madrid",        nationality: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", goals: 14, assists: 10, appearances: 28, league: "La Liga"),
    TopScorer(rank: 12, name: "Lamine Yamal",        team: "FC Barcelona",       nationality: "🇪🇸", goals: 14, assists: 16, appearances: 28, league: "La Liga"),
    TopScorer(rank: 13, name: "Donyell Malen",       team: "Borussia Dortmund",  nationality: "🇳🇱", goals: 14, assists: 8,  appearances: 26, league: "Bundesliga"),
    TopScorer(rank: 14, name: "Marcus Rashford",     team: "Manchester United",  nationality: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", goals: 12, assists: 6,  appearances: 26, league: "Premier League"),
    TopScorer(rank: 15, name: "Nicolo Barella",      team: "Inter Milan",        nationality: "🇮🇹", goals: 7,  assists: 11, appearances: 28, league: "Serie A"),
]

struct TopScorersView: View {
    @StateObject private var imageService = ImageService.shared
    @State private var selectedLeague = "All"
    let leagues = ["All", "Premier League", "La Liga", "Bundesliga", "Serie A", "Ligue 1"]

    private var seasonLabel: String { "2025/26 · sample data" }

    var filtered: [TopScorer] {
        selectedLeague == "All" ? sampleTopScorers : sampleTopScorers.filter { $0.league == selectedLeague }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("FootyHub Golden Boot")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(Date.now.formatted(.dateTime.month(.abbreviated).day().year()))
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    Text(seasonLabel)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)

                if selectedLeague == "All" {
                    PodiumView(scorers: Array(sampleTopScorers.prefix(3)))
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(colors: [Color.blue.opacity(0.1), Color.clear],
                                           startPoint: .top, endPoint: .bottom)
                        )
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(leagues, id: \.self) { league in
                            Button(action: { selectedLeague = league }) {
                                Text(league)
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(selectedLeague == league ? Color.blue : Color(.tertiarySystemBackground))
                                    .foregroundColor(selectedLeague == league ? .white : .secondary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(Array(filtered.enumerated()), id: \.element.id) { index, scorer in
                            ScorerRowView(scorer: scorer, rank: index + 1)
                                .onAppear { imageService.fetchPlayerImage(scorer.name) }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("Top Scorers")
        }
    }
}

struct PodiumView: View {
    let scorers: [TopScorer]
    @StateObject private var imageService = ImageService.shared

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            if scorers.count > 1 {
                PodiumCard(scorer: scorers[1], rank: 2, height: 80)
            }
            if scorers.count > 0 {
                PodiumCard(scorer: scorers[0], rank: 1, height: 110)
            }
            if scorers.count > 2 {
                PodiumCard(scorer: scorers[2], rank: 3, height: 60)
            }
        }
        .padding(.horizontal)
    }
}

struct PodiumCard: View {
    let scorer: TopScorer
    let rank: Int
    let height: CGFloat
    @StateObject private var imageService = ImageService.shared

    var medalColor: Color {
        switch rank { case 1: return .yellow; case 2: return .gray; default: return .brown }
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(medalColor.opacity(0.2))
                    .frame(width: rank == 1 ? 70 : 55, height: rank == 1 ? 70 : 55)

                if let url = imageService.playerImageURL(scorer.name) {
                    AsyncImage(url: url) { phase in
                        if case .success(let img) = phase {
                            img.resizable().scaledToFill()
                                .frame(width: rank == 1 ? 65 : 50, height: rank == 1 ? 65 : 50)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: rank == 1 ? 28 : 22))
                                .foregroundColor(medalColor)
                        }
                    }
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: rank == 1 ? 28 : 22))
                        .foregroundColor(medalColor)
                }

                Text(rank == 1 ? "🥇" : rank == 2 ? "🥈" : "🥉")
                    .font(.system(size: 16))
                    .offset(x: rank == 1 ? 22 : 18, y: rank == 1 ? 22 : 18)
            }

            Text(scorer.name.components(separatedBy: " ").last ?? scorer.name)
                .font(.system(size: 11, weight: .bold))
                .lineLimit(1)

            Text("\(scorer.goals) goals")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(medalColor)

            Rectangle()
                .fill(medalColor.opacity(0.3))
                .frame(height: height)
                .cornerRadius(8, corners: [.topLeft, .topRight])
                .overlay(
                    Text("#\(rank)")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(medalColor)
                        .padding(.top, 8),
                    alignment: .top
                )
        }
        .frame(maxWidth: .infinity)
    }
}

struct ScorerRowView: View {
    let scorer: TopScorer
    let rank: Int
    @StateObject private var imageService = ImageService.shared

    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(rank <= 3 ? .blue : .secondary)
                .frame(width: 24, alignment: .center)

            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 46, height: 46)

                if let url = imageService.playerImageURL(scorer.name) {
                    AsyncImage(url: url) { phase in
                        if case .success(let img) = phase {
                            img.resizable().scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.fill").foregroundColor(.blue)
                        }
                    }
                } else {
                    Image(systemName: "person.fill").foregroundColor(.blue)
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(scorer.nationality)
                    Text(scorer.name)
                        .font(.system(size: 14, weight: .bold))
                }
                Text(scorer.team)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                HStack(spacing: 4) {
                    Image(systemName: "soccerball.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 12))
                    Text("\(scorer.goals)")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.blue)
                }
                Text("\(scorer.assists) ast")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
