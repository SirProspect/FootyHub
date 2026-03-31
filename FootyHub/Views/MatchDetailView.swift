//
//  MatchDetailView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/27/26.
//

import SwiftUI

struct MatchEvent: Identifiable {
    let id = UUID()
    let minute: Int
    let type: String
    let player: String
    let team: String
}

struct MatchDetailView: View {
    let match: LiveMatch

    private var fixtureTitle: String {
        "\(match.homeTeam) vs \(match.awayTeam)"
    }

    private var scheduleLine: String {
        if !match.kickoffSummary.isEmpty {
            return match.kickoffSummary
        }
        switch match.status {
        case "live":
            return "Live · \(match.minute)' · \(match.league)"
        case "upcoming":
            return "Kickoff TBD · \(match.league)"
        case "ft":
            return "Full time · \(match.league)"
        default:
            return match.league
        }
    }

    var events: [MatchEvent] {
        var e: [MatchEvent] = []
        if match.homeScore > 0 {
            e.append(MatchEvent(minute: 23, type: "goal",   player: "Haaland",       team: match.homeTeam))
        }
        if match.homeScore > 1 {
            e.append(MatchEvent(minute: 55, type: "goal",   player: "De Bruyne",     team: match.homeTeam))
        }
        if match.awayScore > 0 {
            e.append(MatchEvent(minute: 38, type: "goal",   player: "Mbappé",        team: match.awayTeam))
        }
        if match.awayScore > 1 {
            e.append(MatchEvent(minute: 62, type: "goal",   player: "Bellingham",    team: match.awayTeam))
        }
        e.append(MatchEvent(minute: 34, type: "yellow", player: "Saliba",        team: match.homeTeam))
        e.append(MatchEvent(minute: 58, type: "yellow", player: "Valverde",      team: match.awayTeam))
        e.append(MatchEvent(minute: 70, type: "sub",    player: "Bernardo Silva", team: match.homeTeam))
        e.append(MatchEvent(minute: 75, type: "sub",    player: "Camavinga",     team: match.awayTeam))
        return e.sorted { $0.minute < $1.minute }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                ZStack {
                    LinearGradient(
                        colors: [Color.blue.opacity(0.85), Color.black.opacity(0.9)],
                        startPoint: .top, endPoint: .bottom
                    )
                    .frame(height: 240)

                    VStack(spacing: 12) {
                        Text(match.league)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Capsule())

                        Text(fixtureTitle)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 12)

                        Text(scheduleLine)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)

                        HStack(spacing: 20) {
                            Text(match.homeTeam)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .lineLimit(2)
                                .multilineTextAlignment(.trailing)

                            HStack(spacing: 8) {
                                Text("\(match.homeScore)")
                                    .font(.system(size: 42, weight: .black))
                                    .foregroundColor(.white)
                                Text("-")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white.opacity(0.5))
                                Text("\(match.awayScore)")
                                    .font(.system(size: 42, weight: .black))
                                    .foregroundColor(.white)
                            }

                            Text(match.awayTeam)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                        }
                        .padding(.horizontal)

                        if match.status == "live" {
                            HStack(spacing: 5) {
                                Circle().fill(Color.red).frame(width: 7, height: 7)
                                Text("LIVE \(match.minute)'")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Color.red.opacity(0.15))
                            .clipShape(Capsule())
                        } else if match.status == "ft" {
                            Text("FULL TIME")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.green)
                        } else {
                            Text("UPCOMING")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.orange)
                        }
                    }
                }

                VStack(spacing: 16) {

                    GlassCard {
                        VStack(spacing: 14) {
                            Text("Match Stats")
                                .font(.system(size: 15, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            MatchStatBar(label: "Possession",  home: 58, away: 42, unit: "%")
                            MatchStatBar(label: "Shots",       home: 14, away: 8,  unit: "")
                            MatchStatBar(label: "Shots on Target", home: 6, away: 3, unit: "")
                            MatchStatBar(label: "Corners",     home: 7,  away: 4,  unit: "")
                            MatchStatBar(label: "Fouls",       home: 9,  away: 12, unit: "")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    GlassCard {
                        VStack(spacing: 12) {
                            Text("Match Events")
                                .font(.system(size: 15, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(events) { event in
                                MatchEventRow(event: event, homeTeam: match.homeTeam)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle("Match Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MatchStatBar: View {
    let label: String
    let home: Int
    let away: Int
    let unit: String

    var homeRatio: Double {
        let total = Double(home + away)
        return total > 0 ? Double(home) / total : 0.5
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("\(home)\(unit)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.blue)
                Spacer()
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(away)\(unit)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.red)
            }

            GeometryReader { geo in
                HStack(spacing: 2) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.blue)
                        .frame(width: max(0, geo.size.width * homeRatio - 1), height: 6)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.red)
                        .frame(width: max(0, geo.size.width * (1 - homeRatio) - 1), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

struct MatchEventRow: View {
    let event: MatchEvent
    let homeTeam: String

    var isHome: Bool { event.team == homeTeam }

    var eventIcon: String {
        switch event.type {
        case "goal":   return "⚽"
        case "yellow": return "🟨"
        case "red":    return "🟥"
        case "sub":    return "🔄"
        default:       return "•"
        }
    }

    var body: some View {
        HStack {
            if isHome {
                Text(event.player)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(eventIcon).font(.system(size: 16))
                Text("\(event.minute)'")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(width: 36, alignment: .center)
                Text("").frame(maxWidth: .infinity)
            } else {
                Text("").frame(maxWidth: .infinity)
                Text("\(event.minute)'")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(width: 36, alignment: .center)
                Text(eventIcon).font(.system(size: 16))
                Text(event.player)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
