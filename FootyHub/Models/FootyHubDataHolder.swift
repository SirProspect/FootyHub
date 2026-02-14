//
//  FootyHubDataHolder.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/8/26.
//

import SwiftUI
import CoreData
import Combine
import FirebaseFirestore

final class FootyHubDataHolder: ObservableObject {

    @Published var teams: [Team] = []
    @Published var players: [Player] = []
    @Published var isLoading: Bool = false

    private let db = Firestore.firestore()

    init(_ context: NSManagedObjectContext) {
        refreshTeams(context)
        refreshPlayers(context)
    }

    func refreshTeams(_ context: NSManagedObjectContext) {
        teams = fetchLocalTeams(context)
    }

    func refreshPlayers(_ context: NSManagedObjectContext) {
        players = fetchLocalPlayers(context)
    }

    private func fetchLocalTeams(_ context: NSManagedObjectContext) -> [Team] {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Team.name, ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }

    private func fetchLocalPlayers(_ context: NSManagedObjectContext) -> [Player] {
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Player.name, ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }

    func fetchTeamsFromFirestore(_ context: NSManagedObjectContext) {
        if !teams.isEmpty { return }
        isLoading = true
        db.collection("teams").getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let documents = snapshot?.documents else { return }

                let existing = self?.fetchLocalTeams(context) ?? []
                for t in existing { context.delete(t) }

                var seenNames: Set<String> = []
                for doc in documents {
                    let data = doc.data()
                    let name = data["name"] as? String ?? ""
                    if seenNames.contains(name) { continue }
                    seenNames.insert(name)

                    let team = Team(context: context)
                    team.id = UUID()
                    team.name = name
                    team.league = data["league"] as? String ?? ""
                    team.country = data["country"] as? String ?? ""
                    team.founded = Int32(data["founded"] as? Int ?? 0)
                    team.stadium = data["stadium"] as? String ?? ""
                    team.wins = Int32(data["wins"] as? Int ?? 0)
                    team.draws = Int32(data["draws"] as? Int ?? 0)
                    team.losses = Int32(data["losses"] as? Int ?? 0)
                    team.goalsScored = Int32(data["goalsScored"] as? Int ?? 0)
                    team.goalsConceded = Int32(data["goalsConceded"] as? Int ?? 0)
                }

                self?.saveContext(context)
            }
        }
    }

    func fetchPlayersFromFirestore(_ context: NSManagedObjectContext) {
        if !players.isEmpty { return }
        isLoading = true
        db.collection("players").getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let documents = snapshot?.documents else { return }

                let existing = self?.fetchLocalPlayers(context) ?? []
                for p in existing { context.delete(p) }

                var seenNames: Set<String> = []
                for doc in documents {
                    let data = doc.data()
                    let name = data["name"] as? String ?? ""
                    if seenNames.contains(name) { continue }
                    seenNames.insert(name)

                    let player = Player(context: context)
                    player.id = UUID()
                    player.name = name
                    player.team = data["team"] as? String ?? ""
                    player.position = data["position"] as? String ?? ""
                    player.nationality = data["nationality"] as? String ?? ""
                    player.age = Int32(data["age"] as? Int ?? 0)
                    player.rating = data["rating"] as? Double ?? 0.0
                    player.goals = Int32(data["goals"] as? Int ?? 0)
                    player.assists = Int32(data["assists"] as? Int ?? 0)
                    player.appearances = Int32(data["appearances"] as? Int ?? 0)
                }

                self?.saveContext(context)
            }
        }
    }

    func clearLocalData(_ context: NSManagedObjectContext) {
        let existingTeams = fetchLocalTeams(context)
        for t in existingTeams { context.delete(t) }

        let existingPlayers = fetchLocalPlayers(context)
        for p in existingPlayers { context.delete(p) }

        saveContext(context)
    }

    func seedSampleData(_ context: NSManagedObjectContext) {
        clearLocalData(context)
        deleteFirestoreCollection("teams") { [weak self] in
            self?.seedTeams()
        }
        deleteFirestoreCollection("players") { [weak self] in
            self?.seedPlayers()
        }
    }

    private func deleteFirestoreCollection(_ name: String, completion: @escaping () -> Void) {
        db.collection(name).getDocuments { snapshot, _ in
            guard let docs = snapshot?.documents else {
                completion()
                return
            }
            for doc in docs {
                doc.reference.delete()
            }
            completion()
        }
    }

    private func seedTeams() {
        let teams: [[String: Any]] = [
            ["name": "FC Barcelona", "league": "La Liga", "country": "Spain", "founded": 1899, "stadium": "Spotify Camp Nou", "wins": 20, "draws": 5, "losses": 3, "goalsScored": 62, "goalsConceded": 20],
            ["name": "Real Madrid", "league": "La Liga", "country": "Spain", "founded": 1902, "stadium": "Santiago Bernabéu", "wins": 19, "draws": 6, "losses": 3, "goalsScored": 58, "goalsConceded": 18],
            ["name": "Manchester City", "league": "Premier League", "country": "England", "founded": 1880, "stadium": "Etihad Stadium", "wins": 22, "draws": 4, "losses": 2, "goalsScored": 70, "goalsConceded": 22],
            ["name": "Liverpool", "league": "Premier League", "country": "England", "founded": 1892, "stadium": "Anfield", "wins": 18, "draws": 7, "losses": 3, "goalsScored": 55, "goalsConceded": 21],
            ["name": "Paris Saint-Germain", "league": "Ligue 1", "country": "France", "founded": 1970, "stadium": "Parc des Princes", "wins": 21, "draws": 4, "losses": 3, "goalsScored": 65, "goalsConceded": 19],
            ["name": "Bayern Munich", "league": "Bundesliga", "country": "Germany", "founded": 1900, "stadium": "Allianz Arena", "wins": 20, "draws": 5, "losses": 3, "goalsScored": 68, "goalsConceded": 23],
            ["name": "Juventus", "league": "Serie A", "country": "Italy", "founded": 1897, "stadium": "Allianz Stadium", "wins": 16, "draws": 8, "losses": 4, "goalsScored": 48, "goalsConceded": 20],
            ["name": "Inter Miami", "league": "MLS", "country": "United States", "founded": 2018, "stadium": "Chase Stadium", "wins": 14, "draws": 6, "losses": 8, "goalsScored": 45, "goalsConceded": 35]
        ]

        for team in teams {
            db.collection("teams").addDocument(data: team)
        }
    }

    private func seedPlayers() {
        let players: [[String: Any]] = [
            ["name": "Lionel Messi", "team": "Inter Miami", "position": "Forward", "nationality": "Argentina", "age": 38, "rating": 9.2, "goals": 15, "assists": 18, "appearances": 28],
            ["name": "Cristiano Ronaldo", "team": "Al Nassr", "position": "Forward", "nationality": "Portugal", "age": 41, "rating": 8.8, "goals": 22, "assists": 5, "appearances": 30],
            ["name": "Kylian Mbappé", "team": "Real Madrid", "position": "Forward", "nationality": "France", "age": 27, "rating": 9.3, "goals": 28, "assists": 10, "appearances": 32],
            ["name": "Erling Haaland", "team": "Manchester City", "position": "Forward", "nationality": "Norway", "age": 25, "rating": 9.4, "goals": 32, "assists": 6, "appearances": 30],
            ["name": "Mohamed Salah", "team": "Liverpool", "position": "Forward", "nationality": "Egypt", "age": 33, "rating": 8.9, "goals": 20, "assists": 12, "appearances": 28],
            ["name": "Vinícius Jr", "team": "Real Madrid", "position": "Forward", "nationality": "Brazil", "age": 25, "rating": 9.1, "goals": 18, "assists": 14, "appearances": 30],
            ["name": "Jude Bellingham", "team": "Real Madrid", "position": "Midfielder", "nationality": "England", "age": 22, "rating": 9.0, "goals": 14, "assists": 10, "appearances": 28],
            ["name": "Kevin De Bruyne", "team": "Manchester City", "position": "Midfielder", "nationality": "Belgium", "age": 34, "rating": 8.7, "goals": 8, "assists": 16, "appearances": 25],
            ["name": "Robert Lewandowski", "team": "FC Barcelona", "position": "Forward", "nationality": "Poland", "age": 37, "rating": 8.8, "goals": 24, "assists": 7, "appearances": 30],
            ["name": "Lamine Yamal", "team": "FC Barcelona", "position": "Forward", "nationality": "Spain", "age": 18, "rating": 8.9, "goals": 12, "assists": 15, "appearances": 28]
        ]

        for player in players {
            db.collection("players").addDocument(data: player)
        }
    }

    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshTeams(context)
            refreshPlayers(context)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
