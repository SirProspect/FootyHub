//
//  SportsDBService.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/7/26.
//

import Foundation
import CoreData
import FirebaseFirestore

class SportsDBService {
    static let shared = SportsDBService()
    private let base = "https://www.thesportsdb.com/api/v1/json/3"
    private let db = Firestore.firestore()

    private let leagues = [
        "English Premier League",
        "Spanish La Liga",
        "German Bundesliga",
        "Italian Serie A",
        "French Ligue 1"
    ]

    func fetchAndStoreTeams(context: NSManagedObjectContext, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        var allTeams: [[String: Any]] = []

        for league in leagues {
            group.enter()
            let encoded = league.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? league
            let urlStr = "\(base)/search_all_teams.php?l=\(encoded)"
            guard let url = URL(string: urlStr) else { group.leave(); continue }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                defer { group.leave() }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let teams = json["teams"] as? [[String: Any]] else { return }
                allTeams.append(contentsOf: teams)
            }.resume()
        }

        group.notify(queue: .main) {
            self.storeTeams(allTeams, context: context)
            completion()
        }
    }

    private func storeTeams(_ teams: [[String: Any]], context: NSManagedObjectContext) {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        if let existing = try? context.fetch(request) {
            existing.forEach { context.delete($0) }
        }

        db.collection("teams").getDocuments { snap, _ in
            snap?.documents.forEach { $0.reference.delete() }
        }

        var seenNames: Set<String> = []
        for t in teams {
            let name = t["strTeam"] as? String ?? ""
            guard !name.isEmpty, !seenNames.contains(name) else { continue }
            seenNames.insert(name)

            let team = Team(context: context)
            team.id       = UUID()
            team.name     = name
            team.league   = t["strLeague"]   as? String ?? ""
            team.country  = t["strCountry"]  as? String ?? ""
            team.stadium  = t["strStadium"]  as? String ?? ""
            team.founded  = Int32(t["intFormedYear"] as? String ?? "0") ?? 0
            team.wins     = 0
            team.draws    = 0
            team.losses   = 0
            team.goalsScored    = 0
            team.goalsConceded  = 0

            let firestoreData: [String: Any] = [
                "name":     team.name ?? "",
                "league":   team.league ?? "",
                "country":  team.country ?? "",
                "stadium":  team.stadium ?? "",
                "founded":  team.founded,
                "wins":     0,
                "draws":    0,
                "losses":   0,
                "goalsScored":   0,
                "goalsConceded": 0
            ]
            self.db.collection("teams").addDocument(data: firestoreData)
        }

        try? context.save()
    }

    func fetchAndStorePlayers(context: NSManagedObjectContext, completion: @escaping () -> Void) {
        let teamIDs = [
            "133604", // Arsenal
            "133612", // Manchester City
            "133616", // Liverpool
            "133602", // Chelsea
            "133610", // Manchester United
            "133919", // Real Madrid
            "133907", // FC Barcelona
            "133736", // Bayern Munich
            "133775", // Juventus
            "133921", // Atletico Madrid
        ]

        let group = DispatchGroup()
        var allPlayers: [[String: Any]] = []

        for id in teamIDs {
            group.enter()
            let urlStr = "\(base)/lookup_all_players.php?id=\(id)"
            guard let url = URL(string: urlStr) else { group.leave(); continue }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                defer { group.leave() }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let players = json["player"] as? [[String: Any]] else { return }
                allPlayers.append(contentsOf: players)
            }.resume()
        }

        group.notify(queue: .main) {
            self.storePlayers(allPlayers, context: context)
            completion()
        }
    }

    private func storePlayers(_ players: [[String: Any]], context: NSManagedObjectContext) {
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        if let existing = try? context.fetch(request) {
            existing.forEach { context.delete($0) }
        }

        db.collection("players").getDocuments { snap, _ in
            snap?.documents.forEach { $0.reference.delete() }
        }

        var seenNames: Set<String> = []
        for p in players {
            let name = p["strPlayer"] as? String ?? ""
            guard !name.isEmpty, !seenNames.contains(name) else { continue }
            seenNames.insert(name)

            let player = Player(context: context)
            player.id           = UUID()
            player.name         = name
            player.team         = p["strTeam"]        as? String ?? ""
            player.position     = p["strPosition"]    as? String ?? ""
            player.nationality  = p["strNationality"] as? String ?? ""
            player.age          = Int32(p["strAge"] as? String ?? "0") ?? 0
            player.rating       = Double.random(in: 7.0...9.5).rounded(toPlaces: 1)
            player.goals        = Int32.random(in: 0...25)
            player.assists      = Int32.random(in: 0...20)
            player.appearances  = Int32.random(in: 10...35)

            let firestoreData: [String: Any] = [
                "name":        player.name ?? "",
                "team":        player.team ?? "",
                "position":    player.position ?? "",
                "nationality": player.nationality ?? "",
                "age":         player.age,
                "rating":      player.rating,
                "goals":       player.goals,
                "assists":     player.assists,
                "appearances": player.appearances
            ]
            self.db.collection("players").addDocument(data: firestoreData)
        }

        try? context.save()
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
