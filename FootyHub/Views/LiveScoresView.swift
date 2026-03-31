//
//  LiveScoresView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/1/26.
//

import SwiftUI
import FirebaseFirestore

struct LiveMatch: Identifiable {
    let id: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int
    let awayScore: Int
    let minute: Int
    let status: String   
    let league: String
    let kickoffSummary: String
}

class LiveScoresViewModel: ObservableObject {
    @Published var matches: [LiveMatch] = []
    @Published var isLoading: Bool = true

    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()

    init() {
        startListening()
    }

    func startListening() {
        isLoading = true
        listener = db.collection("liveScores")
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    guard let docs = snapshot?.documents else { return }
                    self?.matches = docs.compactMap { doc -> LiveMatch? in
                        let d = doc.data()
                        return LiveMatch(
                            id: doc.documentID,
                            homeTeam:  d["homeTeam"]  as? String ?? "",
                            awayTeam:  d["awayTeam"]  as? String ?? "",
                            homeScore: d["homeScore"] as? Int    ?? 0,
                            awayScore: d["awayScore"] as? Int    ?? 0,
                            minute:    d["minute"]    as? Int    ?? 0,
                            status:    d["status"]    as? String ?? "ft",
                            league:    d["league"]    as? String ?? "",
                            kickoffSummary: d["kickoffSummary"] as? String ?? ""
                        )
                    }
                    .sorted { a, b in
                        let order = ["live": 0, "upcoming": 1, "ft": 2]
                        return (order[a.status] ?? 3) < (order[b.status] ?? 3)
                    }
                }
            }
    }

    func seedLiveScores() {
        let matches: [[String: Any]] = [
            ["homeTeam": "FC Barcelona",    "awayTeam": "Real Madrid",   "homeScore": 2, "awayScore": 1, "minute": 67, "status": "live",     "league": "La Liga", "kickoffSummary": "Sat, Mar 29 · 21:00"],
            ["homeTeam": "Manchester City", "awayTeam": "Liverpool",     "homeScore": 1, "awayScore": 1, "minute": 45, "status": "live",     "league": "Premier League", "kickoffSummary": "Sun, Mar 30 · 17:30"],
            ["homeTeam": "Bayern Munich",   "awayTeam": "Juventus",      "homeScore": 3, "awayScore": 0, "minute": 90, "status": "ft",       "league": "Champions League", "kickoffSummary": "Tue, Mar 25 · 20:00"],
            ["homeTeam": "PSG",             "awayTeam": "Inter Miami",   "homeScore": 0, "awayScore": 0, "minute": 0,  "status": "upcoming", "league": "Friendly", "kickoffSummary": "Wed, Apr 2 · 19:45"],
        ]
        for match in matches {
            db.collection("liveScores").addDocument(data: match)
        }
    }

    deinit {
        listener?.remove()
    }
}

struct LiveScoresView: View {
    @StateObject private var vm = LiveScoresViewModel()
    @State private var showSeedAlert = false

    var liveMatches:     [LiveMatch] { vm.matches.filter { $0.status == "live" } }
    var upcomingMatches: [LiveMatch] { vm.matches.filter { $0.status == "upcoming" } }
    var finishedMatches: [LiveMatch] { vm.matches.filter { $0.status == "ft" } }

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading scores...")
                } else if vm.matches.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "sportscourt")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No matches yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Button("Seed Sample Matches") {
                            showSeedAlert = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        if !liveMatches.isEmpty {
                            Section(header: Text("🔴 LIVE").font(.caption).fontWeight(.bold).foregroundColor(.red)) {
                                ForEach(liveMatches) { match in
                                    NavigationLink(destination: MatchDetailView(match: match)) {
                                        MatchRowView(match: match)
                                    }
                                }
                            }
                        }
                        if !upcomingMatches.isEmpty {
                            Section(header: Text("🕐 UPCOMING").font(.caption).fontWeight(.bold).foregroundColor(.orange)) {
                                ForEach(upcomingMatches) { match in
                                    NavigationLink(destination: MatchDetailView(match: match)) {
                                        MatchRowView(match: match)
                                    }
                                }
                            }
                        }
                        if !finishedMatches.isEmpty {
                            Section(header: Text("✅ FULL TIME").font(.caption).fontWeight(.bold).foregroundColor(.gray)) {
                                ForEach(finishedMatches) { match in
                                    NavigationLink(destination: MatchDetailView(match: match)) {
                                        MatchRowView(match: match)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Live Scores")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSeedAlert = true }) {
                        Image(systemName: "arrow.down.circle")
                    }
                }
            }
            .alert("Seed Matches", isPresented: $showSeedAlert) {
                Button("Seed") { vm.seedLiveScores() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Add sample live match data to Firestore?")
            }
        }
    }
}

struct MatchRowView: View {
    let match: LiveMatch

    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 4) {
                Text(match.league)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                if !match.kickoffSummary.isEmpty {
                    Text(match.kickoffSummary)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            HStack {
                Text(match.homeTeam)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                HStack(spacing: 4) {
                    Text("\(match.homeScore)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(match.status == "live" ? .red : .primary)
                    Text("-")
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    Text("\(match.awayScore)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(match.status == "live" ? .red : .primary)
                }
                .padding(.horizontal, 8)

                Text(match.awayTeam)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Group {
                if match.status == "live" {
                    HStack(spacing: 4) {
                        Circle().fill(Color.red).frame(width: 6, height: 6)
                        Text("\(match.minute)'").font(.caption).fontWeight(.bold).foregroundColor(.red)
                    }
                } else if match.status == "upcoming" {
                    Text("Upcoming").font(.caption).foregroundColor(.orange)
                } else {
                    Text("Full Time").font(.caption).foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 6)
    }
}
