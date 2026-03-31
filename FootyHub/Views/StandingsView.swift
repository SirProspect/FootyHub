//
//  StandingsView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/19/26.
//

import SwiftUI

struct LeagueStanding: Identifiable {
    let id = UUID()
    let position: Int
    let teamName: String
    let played: Int
    let wins: Int
    let draws: Int
    let losses: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let points: Int
    var goalDiff: Int { goalsFor - goalsAgainst }
}

struct LeagueStandingData: Identifiable {
    let id = UUID()
    let leagueName: String
    let country: String
    let flag: String
    let standings: [LeagueStanding]
}

let sampleStandings: [LeagueStandingData] = [
    LeagueStandingData(leagueName: "Premier League", country: "England", flag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", standings: [
        LeagueStanding(position: 1,  teamName: "Manchester City",    played: 28, wins: 22, draws: 4, losses: 2,  goalsFor: 70, goalsAgainst: 22, points: 70),
        LeagueStanding(position: 2,  teamName: "Liverpool",          played: 28, wins: 20, draws: 5, losses: 3,  goalsFor: 62, goalsAgainst: 25, points: 65),
        LeagueStanding(position: 3,  teamName: "Arsenal",            played: 28, wins: 19, draws: 6, losses: 3,  goalsFor: 58, goalsAgainst: 24, points: 63),
        LeagueStanding(position: 4,  teamName: "Chelsea",            played: 28, wins: 15, draws: 7, losses: 6,  goalsFor: 50, goalsAgainst: 35, points: 52),
        LeagueStanding(position: 5,  teamName: "Tottenham Hotspur",  played: 28, wins: 14, draws: 5, losses: 9,  goalsFor: 48, goalsAgainst: 40, points: 47),
        LeagueStanding(position: 6,  teamName: "Manchester United",  played: 28, wins: 13, draws: 6, losses: 9,  goalsFor: 42, goalsAgainst: 38, points: 45),
        LeagueStanding(position: 7,  teamName: "Newcastle United",   played: 28, wins: 13, draws: 5, losses: 10, goalsFor: 45, goalsAgainst: 38, points: 44),
        LeagueStanding(position: 8,  teamName: "Aston Villa",        played: 28, wins: 12, draws: 6, losses: 10, goalsFor: 44, goalsAgainst: 40, points: 42),
        LeagueStanding(position: 9,  teamName: "West Ham United",    played: 28, wins: 11, draws: 7, losses: 10, goalsFor: 40, goalsAgainst: 42, points: 40),
        LeagueStanding(position: 10, teamName: "Brighton",           played: 28, wins: 11, draws: 6, losses: 11, goalsFor: 42, goalsAgainst: 44, points: 39),
        LeagueStanding(position: 11, teamName: "Brentford",          played: 28, wins: 10, draws: 7, losses: 11, goalsFor: 38, goalsAgainst: 42, points: 37),
        LeagueStanding(position: 12, teamName: "Fulham",             played: 28, wins: 10, draws: 6, losses: 12, goalsFor: 36, goalsAgainst: 44, points: 36),
        LeagueStanding(position: 13, teamName: "Crystal Palace",     played: 28, wins: 9,  draws: 7, losses: 12, goalsFor: 34, goalsAgainst: 44, points: 34),
        LeagueStanding(position: 14, teamName: "Wolverhampton",      played: 28, wins: 8,  draws: 8, losses: 12, goalsFor: 32, goalsAgainst: 46, points: 32),
        LeagueStanding(position: 15, teamName: "Everton",            played: 28, wins: 7,  draws: 9, losses: 12, goalsFor: 30, goalsAgainst: 46, points: 30),
        LeagueStanding(position: 16, teamName: "Nottingham Forest",  played: 28, wins: 7,  draws: 8, losses: 13, goalsFor: 28, goalsAgainst: 48, points: 29),
        LeagueStanding(position: 17, teamName: "Bournemouth",        played: 28, wins: 6,  draws: 9, losses: 13, goalsFor: 28, goalsAgainst: 50, points: 27),
        LeagueStanding(position: 18, teamName: "Burnley",            played: 28, wins: 5,  draws: 7, losses: 16, goalsFor: 24, goalsAgainst: 58, points: 22),
        LeagueStanding(position: 19, teamName: "Sheffield United",   played: 28, wins: 4,  draws: 6, losses: 18, goalsFor: 20, goalsAgainst: 62, points: 18),
        LeagueStanding(position: 20, teamName: "Luton Town",         played: 28, wins: 3,  draws: 5, losses: 20, goalsFor: 18, goalsAgainst: 68, points: 14),
    ]),
    LeagueStandingData(leagueName: "La Liga", country: "Spain", flag: "🇪🇸", standings: [
        LeagueStanding(position: 1,  teamName: "Real Madrid",        played: 28, wins: 21, draws: 5, losses: 2,  goalsFor: 65, goalsAgainst: 20, points: 68),
        LeagueStanding(position: 2,  teamName: "FC Barcelona",       played: 28, wins: 20, draws: 4, losses: 4,  goalsFor: 60, goalsAgainst: 22, points: 64),
        LeagueStanding(position: 3,  teamName: "Atletico Madrid",    played: 28, wins: 17, draws: 8, losses: 3,  goalsFor: 48, goalsAgainst: 20, points: 59),
        LeagueStanding(position: 4,  teamName: "Sevilla",            played: 28, wins: 12, draws: 6, losses: 10, goalsFor: 38, goalsAgainst: 36, points: 42),
        LeagueStanding(position: 5,  teamName: "Real Sociedad",      played: 28, wins: 12, draws: 5, losses: 11, goalsFor: 36, goalsAgainst: 36, points: 41),
        LeagueStanding(position: 6,  teamName: "Athletic Bilbao",    played: 28, wins: 11, draws: 7, losses: 10, goalsFor: 35, goalsAgainst: 34, points: 40),
        LeagueStanding(position: 7,  teamName: "Villarreal",         played: 28, wins: 11, draws: 6, losses: 11, goalsFor: 38, goalsAgainst: 38, points: 39),
        LeagueStanding(position: 8,  teamName: "Real Betis",         played: 28, wins: 10, draws: 8, losses: 10, goalsFor: 34, goalsAgainst: 36, points: 38),
        LeagueStanding(position: 9,  teamName: "Valencia",           played: 28, wins: 10, draws: 6, losses: 12, goalsFor: 32, goalsAgainst: 38, points: 36),
        LeagueStanding(position: 10, teamName: "Osasuna",            played: 28, wins: 9,  draws: 7, losses: 12, goalsFor: 30, goalsAgainst: 38, points: 34),
        LeagueStanding(position: 11, teamName: "Girona",             played: 28, wins: 9,  draws: 6, losses: 13, goalsFor: 32, goalsAgainst: 40, points: 33),
        LeagueStanding(position: 12, teamName: "Celta Vigo",         played: 28, wins: 8,  draws: 8, losses: 12, goalsFor: 30, goalsAgainst: 40, points: 32),
        LeagueStanding(position: 13, teamName: "Rayo Vallecano",     played: 28, wins: 8,  draws: 7, losses: 13, goalsFor: 28, goalsAgainst: 40, points: 31),
        LeagueStanding(position: 14, teamName: "Getafe",             played: 28, wins: 7,  draws: 9, losses: 12, goalsFor: 26, goalsAgainst: 38, points: 30),
        LeagueStanding(position: 15, teamName: "Mallorca",           played: 28, wins: 7,  draws: 8, losses: 13, goalsFor: 26, goalsAgainst: 40, points: 29),
        LeagueStanding(position: 16, teamName: "Las Palmas",         played: 28, wins: 6,  draws: 9, losses: 13, goalsFor: 24, goalsAgainst: 42, points: 27),
        LeagueStanding(position: 17, teamName: "Deportivo Alaves",   played: 28, wins: 6,  draws: 7, losses: 15, goalsFor: 22, goalsAgainst: 46, points: 25),
        LeagueStanding(position: 18, teamName: "Cadiz",              played: 28, wins: 4,  draws: 8, losses: 16, goalsFor: 20, goalsAgainst: 50, points: 20),
        LeagueStanding(position: 19, teamName: "Granada",            played: 28, wins: 3,  draws: 7, losses: 18, goalsFor: 18, goalsAgainst: 56, points: 16),
        LeagueStanding(position: 20, teamName: "Almeria",            played: 28, wins: 2,  draws: 6, losses: 20, goalsFor: 16, goalsAgainst: 62, points: 12),
    ]),
    LeagueStandingData(leagueName: "Bundesliga", country: "Germany", flag: "🇩🇪", standings: [
        LeagueStanding(position: 1,  teamName: "Bayern Munich",      played: 27, wins: 22, draws: 3, losses: 2,  goalsFor: 72, goalsAgainst: 24, points: 69),
        LeagueStanding(position: 2,  teamName: "Bayer Leverkusen",   played: 27, wins: 18, draws: 6, losses: 3,  goalsFor: 58, goalsAgainst: 28, points: 60),
        LeagueStanding(position: 3,  teamName: "Borussia Dortmund",  played: 27, wins: 17, draws: 5, losses: 5,  goalsFor: 55, goalsAgainst: 30, points: 56),
        LeagueStanding(position: 4,  teamName: "RB Leipzig",         played: 27, wins: 15, draws: 5, losses: 7,  goalsFor: 50, goalsAgainst: 34, points: 50),
        LeagueStanding(position: 5,  teamName: "Eintracht Frankfurt", played: 27, wins: 13, draws: 6, losses: 8, goalsFor: 44, goalsAgainst: 36, points: 45),
        LeagueStanding(position: 6,  teamName: "Freiburg",           played: 27, wins: 12, draws: 6, losses: 9,  goalsFor: 40, goalsAgainst: 36, points: 42),
        LeagueStanding(position: 7,  teamName: "Wolfsburg",          played: 27, wins: 11, draws: 7, losses: 9,  goalsFor: 38, goalsAgainst: 36, points: 40),
        LeagueStanding(position: 8,  teamName: "Borussia Monchengladbach", played: 27, wins: 10, draws: 8, losses: 9, goalsFor: 36, goalsAgainst: 38, points: 38),
        LeagueStanding(position: 9,  teamName: "Union Berlin",       played: 27, wins: 10, draws: 6, losses: 11, goalsFor: 34, goalsAgainst: 40, points: 36),
        LeagueStanding(position: 10, teamName: "Stuttgart",          played: 27, wins: 9,  draws: 7, losses: 11, goalsFor: 34, goalsAgainst: 40, points: 34),
        LeagueStanding(position: 11, teamName: "Mainz",              played: 27, wins: 8,  draws: 8, losses: 11, goalsFor: 30, goalsAgainst: 40, points: 32),
        LeagueStanding(position: 12, teamName: "Hoffenheim",         played: 27, wins: 8,  draws: 6, losses: 13, goalsFor: 30, goalsAgainst: 44, points: 30),
        LeagueStanding(position: 13, teamName: "Werder Bremen",      played: 27, wins: 7,  draws: 8, losses: 12, goalsFor: 28, goalsAgainst: 42, points: 29),
        LeagueStanding(position: 14, teamName: "Augsburg",           played: 27, wins: 7,  draws: 7, losses: 13, goalsFor: 26, goalsAgainst: 44, points: 28),
        LeagueStanding(position: 15, teamName: "Heidenheim",         played: 27, wins: 6,  draws: 7, losses: 14, goalsFor: 24, goalsAgainst: 48, points: 25),
        LeagueStanding(position: 16, teamName: "Bochum",             played: 27, wins: 5,  draws: 7, losses: 15, goalsFor: 22, goalsAgainst: 50, points: 22),
        LeagueStanding(position: 17, teamName: "Cologne",            played: 27, wins: 4,  draws: 6, losses: 17, goalsFor: 20, goalsAgainst: 56, points: 18),
        LeagueStanding(position: 18, teamName: "Darmstadt",          played: 27, wins: 2,  draws: 5, losses: 20, goalsFor: 16, goalsAgainst: 64, points: 11),
    ]),
    LeagueStandingData(leagueName: "Serie A", country: "Italy", flag: "🇮🇹", standings: [
        LeagueStanding(position: 1,  teamName: "Inter Milan",        played: 28, wins: 20, draws: 5, losses: 3,  goalsFor: 60, goalsAgainst: 22, points: 65),
        LeagueStanding(position: 2,  teamName: "Napoli",             played: 28, wins: 18, draws: 4, losses: 6,  goalsFor: 55, goalsAgainst: 28, points: 58),
        LeagueStanding(position: 3,  teamName: "AC Milan",           played: 28, wins: 16, draws: 7, losses: 5,  goalsFor: 50, goalsAgainst: 28, points: 55),
        LeagueStanding(position: 4,  teamName: "Juventus",           played: 28, wins: 15, draws: 8, losses: 5,  goalsFor: 46, goalsAgainst: 26, points: 53),
        LeagueStanding(position: 5,  teamName: "Atalanta",           played: 28, wins: 15, draws: 5, losses: 8,  goalsFor: 52, goalsAgainst: 34, points: 50),
        LeagueStanding(position: 6,  teamName: "AS Roma",            played: 28, wins: 13, draws: 7, losses: 8,  goalsFor: 44, goalsAgainst: 34, points: 46),
        LeagueStanding(position: 7,  teamName: "Lazio",              played: 28, wins: 13, draws: 6, losses: 9,  goalsFor: 44, goalsAgainst: 36, points: 45),
        LeagueStanding(position: 8,  teamName: "Fiorentina",         played: 28, wins: 12, draws: 7, losses: 9,  goalsFor: 40, goalsAgainst: 36, points: 43),
        LeagueStanding(position: 9,  teamName: "Torino",             played: 28, wins: 10, draws: 8, losses: 10, goalsFor: 34, goalsAgainst: 36, points: 38),
        LeagueStanding(position: 10, teamName: "Bologna",            played: 28, wins: 10, draws: 7, losses: 11, goalsFor: 36, goalsAgainst: 40, points: 37),
        LeagueStanding(position: 11, teamName: "Monza",              played: 28, wins: 9,  draws: 8, losses: 11, goalsFor: 32, goalsAgainst: 38, points: 35),
        LeagueStanding(position: 12, teamName: "Udinese",            played: 28, wins: 8,  draws: 9, losses: 11, goalsFor: 30, goalsAgainst: 38, points: 33),
        LeagueStanding(position: 13, teamName: "Genoa",              played: 28, wins: 8,  draws: 8, losses: 12, goalsFor: 28, goalsAgainst: 40, points: 32),
        LeagueStanding(position: 14, teamName: "Lecce",              played: 28, wins: 7,  draws: 9, losses: 12, goalsFor: 26, goalsAgainst: 40, points: 30),
        LeagueStanding(position: 15, teamName: "Hellas Verona",      played: 28, wins: 7,  draws: 8, losses: 13, goalsFor: 26, goalsAgainst: 44, points: 29),
        LeagueStanding(position: 16, teamName: "Cagliari",           played: 28, wins: 6,  draws: 9, losses: 13, goalsFor: 24, goalsAgainst: 44, points: 27),
        LeagueStanding(position: 17, teamName: "Empoli",             played: 28, wins: 6,  draws: 7, losses: 15, goalsFor: 22, goalsAgainst: 48, points: 25),
        LeagueStanding(position: 18, teamName: "Frosinone",          played: 28, wins: 4,  draws: 8, losses: 16, goalsFor: 20, goalsAgainst: 52, points: 20),
        LeagueStanding(position: 19, teamName: "Sassuolo",           played: 28, wins: 3,  draws: 7, losses: 18, goalsFor: 18, goalsAgainst: 58, points: 16),
        LeagueStanding(position: 20, teamName: "Salernitana",        played: 28, wins: 2,  draws: 5, losses: 21, goalsFor: 14, goalsAgainst: 66, points: 11),
    ]),
    LeagueStandingData(leagueName: "Ligue 1", country: "France", flag: "🇫🇷", standings: [
        LeagueStanding(position: 1,  teamName: "Paris Saint-Germain", played: 27, wins: 23, draws: 3, losses: 1,  goalsFor: 72, goalsAgainst: 18, points: 72),
        LeagueStanding(position: 2,  teamName: "Olympique Marseille", played: 27, wins: 16, draws: 6, losses: 5,  goalsFor: 50, goalsAgainst: 28, points: 54),
        LeagueStanding(position: 3,  teamName: "Olympique Lyonnais",  played: 27, wins: 14, draws: 5, losses: 8,  goalsFor: 45, goalsAgainst: 34, points: 47),
        LeagueStanding(position: 4,  teamName: "Monaco",              played: 27, wins: 13, draws: 6, losses: 8,  goalsFor: 44, goalsAgainst: 32, points: 45),
        LeagueStanding(position: 5,  teamName: "Lille",               played: 27, wins: 13, draws: 5, losses: 9,  goalsFor: 40, goalsAgainst: 32, points: 44),
        LeagueStanding(position: 6,  teamName: "Nice",                played: 27, wins: 12, draws: 6, losses: 9,  goalsFor: 38, goalsAgainst: 32, points: 42),
        LeagueStanding(position: 7,  teamName: "Lens",                played: 27, wins: 11, draws: 7, losses: 9,  goalsFor: 36, goalsAgainst: 32, points: 40),
        LeagueStanding(position: 8,  teamName: "Rennes",              played: 27, wins: 10, draws: 8, losses: 9,  goalsFor: 34, goalsAgainst: 34, points: 38),
        LeagueStanding(position: 9,  teamName: "Stade de Reims",      played: 27, wins: 10, draws: 6, losses: 11, goalsFor: 32, goalsAgainst: 36, points: 36),
        LeagueStanding(position: 10, teamName: "Montpellier",         played: 27, wins: 9,  draws: 7, losses: 11, goalsFor: 30, goalsAgainst: 36, points: 34),
        LeagueStanding(position: 11, teamName: "Strasbourg",          played: 27, wins: 8,  draws: 8, losses: 11, goalsFor: 28, goalsAgainst: 36, points: 32),
        LeagueStanding(position: 12, teamName: "Nantes",              played: 27, wins: 8,  draws: 7, losses: 12, goalsFor: 28, goalsAgainst: 38, points: 31),
        LeagueStanding(position: 13, teamName: "Toulouse",            played: 27, wins: 7,  draws: 8, losses: 12, goalsFor: 26, goalsAgainst: 38, points: 29),
        LeagueStanding(position: 14, teamName: "Brest",               played: 27, wins: 7,  draws: 7, losses: 13, goalsFor: 24, goalsAgainst: 40, points: 28),
        LeagueStanding(position: 15, teamName: "Le Havre",            played: 27, wins: 6,  draws: 8, losses: 13, goalsFor: 22, goalsAgainst: 42, points: 26),
        LeagueStanding(position: 16, teamName: "Metz",                played: 27, wins: 5,  draws: 8, losses: 14, goalsFor: 20, goalsAgainst: 44, points: 23),
        LeagueStanding(position: 17, teamName: "Clermont Foot",       played: 27, wins: 4,  draws: 7, losses: 16, goalsFor: 18, goalsAgainst: 50, points: 19),
        LeagueStanding(position: 18, teamName: "Lorient",             played: 27, wins: 2,  draws: 5, losses: 20, goalsFor: 14, goalsAgainst: 60, points: 11),
    ]),
]

struct StandingsView: View {
    @State private var selectedLeague: LeagueStandingData = sampleStandings[0]

    private var seasonLabel: String { "2025/26" }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("FootyHub Standings")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(seasonLabel)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.tertiary)
                    }
                    Text("\(selectedLeague.flag) \(selectedLeague.leagueName) · \(selectedLeague.country)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 6)
                .padding(.bottom, 4)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(sampleStandings) { league in
                            Button(action: { selectedLeague = league }) {
                                HStack(spacing: 6) {
                                    Text(league.flag)
                                    Text(league.leagueName)
                                        .font(.system(size: 13, weight: .semibold))
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selectedLeague.id == league.id ? Color.blue : Color(.tertiarySystemBackground))
                                .foregroundColor(selectedLeague.id == league.id ? .white : .secondary)
                                .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                HStack {
                    Text("#")
                        .frame(width: 24, alignment: .center)
                    Text("Team")
                        .frame(maxWidth: .infinity, alignment: .leading)
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

                NavigationLink(destination: LeagueDetailView(league: selectedLeague)) {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(selectedLeague.standings) { row in
                                StandingRowView(row: row)
                                Divider().padding(.leading, 16)
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("Standings")
        }
    }
}

struct StandingRowView: View {
    let row: LeagueStanding

    var positionColor: Color {
        switch row.position {
        case 1: return .yellow
        case 2, 3: return .blue
        case 4: return .orange
        default: return .clear
        }
    }

    var body: some View {
        HStack {
            ZStack {
                if positionColor != .clear {
                    Circle()
                        .fill(positionColor.opacity(0.2))
                        .frame(width: 24, height: 24)
                }
                Text("\(row.position)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(positionColor == .clear ? .secondary : positionColor)
            }
            .frame(width: 24)

            Text(row.teamName)
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)

            Text("\(row.played)").frame(width: 26, alignment: .center).font(.system(size: 13)).foregroundColor(.secondary)
            Text("\(row.wins)").frame(width: 26, alignment: .center).font(.system(size: 13)).foregroundColor(.green)
            Text("\(row.draws)").frame(width: 26, alignment: .center).font(.system(size: 13)).foregroundColor(.orange)
            Text("\(row.losses)").frame(width: 26, alignment: .center).font(.system(size: 13)).foregroundColor(.red)
            Text(row.goalDiff >= 0 ? "+\(row.goalDiff)" : "\(row.goalDiff)")
                .frame(width: 32, alignment: .center)
                .font(.system(size: 13))
                .foregroundColor(row.goalDiff >= 0 ? .blue : .red)
            Text("\(row.points)")
                .frame(width: 36, alignment: .center)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}
