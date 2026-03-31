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

    // MARK: - Fetch from Real API
    func fetchFromAPI(_ context: NSManagedObjectContext, completion: @escaping () -> Void = {}) {
        isLoading = true
        SportsDBService.shared.fetchAndStoreTeams(context: context) {
            SportsDBService.shared.fetchAndStorePlayers(context: context) {
                DispatchQueue.main.async {
                    self.refreshTeams(context)
                    self.refreshPlayers(context)
                    self.isLoading = false
                    completion()
                }
            }
        }
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
            // Premier League
            ["name": "Manchester City",    "league": "Premier League", "country": "England", "founded": 1880, "stadium": "Etihad Stadium",          "wins": 22, "draws": 4,  "losses": 2,  "goalsScored": 70, "goalsConceded": 22],
            ["name": "Liverpool",          "league": "Premier League", "country": "England", "founded": 1892, "stadium": "Anfield",                  "wins": 20, "draws": 5,  "losses": 3,  "goalsScored": 62, "goalsConceded": 25],
            ["name": "Arsenal",            "league": "Premier League", "country": "England", "founded": 1886, "stadium": "Emirates Stadium",         "wins": 19, "draws": 6,  "losses": 3,  "goalsScored": 58, "goalsConceded": 24],
            ["name": "Chelsea",            "league": "Premier League", "country": "England", "founded": 1905, "stadium": "Stamford Bridge",          "wins": 15, "draws": 7,  "losses": 6,  "goalsScored": 50, "goalsConceded": 35],
            ["name": "Manchester United",  "league": "Premier League", "country": "England", "founded": 1878, "stadium": "Old Trafford",             "wins": 13, "draws": 6,  "losses": 9,  "goalsScored": 42, "goalsConceded": 38],
            ["name": "Tottenham Hotspur",  "league": "Premier League", "country": "England", "founded": 1882, "stadium": "Tottenham Hotspur Stadium", "wins": 14, "draws": 5, "losses": 9,  "goalsScored": 48, "goalsConceded": 40],

            // La Liga
            ["name": "Real Madrid",        "league": "La Liga",        "country": "Spain",   "founded": 1902, "stadium": "Santiago Bernabéu",        "wins": 21, "draws": 5,  "losses": 2,  "goalsScored": 65, "goalsConceded": 20],
            ["name": "FC Barcelona",       "league": "La Liga",        "country": "Spain",   "founded": 1899, "stadium": "Spotify Camp Nou",         "wins": 20, "draws": 4,  "losses": 4,  "goalsScored": 60, "goalsConceded": 22],
            ["name": "Atletico Madrid",    "league": "La Liga",        "country": "Spain",   "founded": 1903, "stadium": "Civitas Metropolitano",    "wins": 17, "draws": 8,  "losses": 3,  "goalsScored": 48, "goalsConceded": 20],
            ["name": "Sevilla",            "league": "La Liga",        "country": "Spain",   "founded": 1890, "stadium": "Estadio Ramón Sánchez Pizjuán", "wins": 12, "draws": 6, "losses": 10, "goalsScored": 38, "goalsConceded": 36],

            // Bundesliga
            ["name": "Bayern Munich",      "league": "Bundesliga",     "country": "Germany", "founded": 1900, "stadium": "Allianz Arena",            "wins": 22, "draws": 3,  "losses": 3,  "goalsScored": 72, "goalsConceded": 24],
            ["name": "Borussia Dortmund",  "league": "Bundesliga",     "country": "Germany", "founded": 1909, "stadium": "Signal Iduna Park",        "wins": 17, "draws": 5,  "losses": 6,  "goalsScored": 55, "goalsConceded": 32],
            ["name": "Bayer Leverkusen",   "league": "Bundesliga",     "country": "Germany", "founded": 1904, "stadium": "BayArena",                 "wins": 18, "draws": 6,  "losses": 4,  "goalsScored": 58, "goalsConceded": 28],

            // Serie A
            ["name": "Inter Milan",        "league": "Serie A",        "country": "Italy",   "founded": 1908, "stadium": "San Siro",                 "wins": 20, "draws": 5,  "losses": 3,  "goalsScored": 60, "goalsConceded": 22],
            ["name": "AC Milan",           "league": "Serie A",        "country": "Italy",   "founded": 1899, "stadium": "San Siro",                 "wins": 16, "draws": 7,  "losses": 5,  "goalsScored": 50, "goalsConceded": 28],
            ["name": "Juventus",           "league": "Serie A",        "country": "Italy",   "founded": 1897, "stadium": "Allianz Stadium",          "wins": 15, "draws": 8,  "losses": 5,  "goalsScored": 46, "goalsConceded": 26],
            ["name": "Napoli",             "league": "Serie A",        "country": "Italy",   "founded": 1926, "stadium": "Stadio Diego Armando Maradona", "wins": 18, "draws": 4, "losses": 6, "goalsScored": 55, "goalsConceded": 28],

            // Ligue 1
            ["name": "Paris Saint-Germain","league": "Ligue 1",        "country": "France",  "founded": 1970, "stadium": "Parc des Princes",         "wins": 23, "draws": 3,  "losses": 2,  "goalsScored": 72, "goalsConceded": 18],
            ["name": "Olympique Marseille","league": "Ligue 1",        "country": "France",  "founded": 1899, "stadium": "Stade Vélodrome",          "wins": 16, "draws": 6,  "losses": 6,  "goalsScored": 50, "goalsConceded": 30],
            ["name": "Olympique Lyonnais", "league": "Ligue 1",        "country": "France",  "founded": 1950, "stadium": "Groupama Stadium",         "wins": 14, "draws": 5,  "losses": 9,  "goalsScored": 45, "goalsConceded": 36],
        ]

        for team in teams {
            db.collection("teams").addDocument(data: team)
        }
    }

    private func seedPlayers() {
        let players: [[String: Any]] = [

            // FORWARDS
            ["name": "Erling Haaland",      "team": "Manchester City",    "position": "Forward",    "nationality": "Norway",      "age": 25, "rating": 9.4, "goals": 32, "assists": 6,  "appearances": 30],
            ["name": "Kylian Mbappé",       "team": "Real Madrid",        "position": "Forward",    "nationality": "France",      "age": 27, "rating": 9.3, "goals": 28, "assists": 10, "appearances": 32],
            ["name": "Vinícius Jr",         "team": "Real Madrid",        "position": "Forward",    "nationality": "Brazil",      "age": 25, "rating": 9.1, "goals": 20, "assists": 14, "appearances": 30],
            ["name": "Mohamed Salah",       "team": "Liverpool",          "position": "Forward",    "nationality": "Egypt",       "age": 33, "rating": 9.0, "goals": 22, "assists": 12, "appearances": 30],
            ["name": "Robert Lewandowski",  "team": "FC Barcelona",       "position": "Forward",    "nationality": "Poland",      "age": 37, "rating": 8.8, "goals": 24, "assists": 7,  "appearances": 30],
            ["name": "Lamine Yamal",        "team": "FC Barcelona",       "position": "Forward",    "nationality": "Spain",       "age": 18, "rating": 8.9, "goals": 14, "assists": 16, "appearances": 28],
            ["name": "Harry Kane",          "team": "Bayern Munich",      "position": "Forward",    "nationality": "England",     "age": 32, "rating": 9.1, "goals": 30, "assists": 8,  "appearances": 32],
            ["name": "Bukayo Saka",         "team": "Arsenal",            "position": "Forward",    "nationality": "England",     "age": 23, "rating": 8.8, "goals": 16, "assists": 14, "appearances": 28],
            ["name": "Marcus Rashford",     "team": "Manchester United",  "position": "Forward",    "nationality": "England",     "age": 27, "rating": 8.2, "goals": 12, "assists": 6,  "appearances": 26],
            ["name": "Olivier Giroud",      "team": "AC Milan",           "position": "Forward",    "nationality": "France",      "age": 38, "rating": 7.9, "goals": 10, "assists": 4,  "appearances": 22],
            ["name": "Victor Osimhen",      "team": "Napoli",             "position": "Forward",    "nationality": "Nigeria",     "age": 26, "rating": 8.9, "goals": 25, "assists": 5,  "appearances": 28],
            ["name": "Donyell Malen",       "team": "Borussia Dortmund",  "position": "Forward",    "nationality": "Netherlands", "age": 26, "rating": 8.0, "goals": 14, "assists": 8,  "appearances": 26],

            // MIDFIELDERS
            ["name": "Jude Bellingham",     "team": "Real Madrid",        "position": "Midfielder", "nationality": "England",     "age": 22, "rating": 9.0, "goals": 14, "assists": 10, "appearances": 28],
            ["name": "Kevin De Bruyne",     "team": "Manchester City",    "position": "Midfielder", "nationality": "Belgium",     "age": 34, "rating": 8.8, "goals": 8,  "assists": 18, "appearances": 26],
            ["name": "Pedri",               "team": "FC Barcelona",       "position": "Midfielder", "nationality": "Spain",       "age": 23, "rating": 8.7, "goals": 8,  "assists": 12, "appearances": 28],
            ["name": "Gavi",                "team": "FC Barcelona",       "position": "Midfielder", "nationality": "Spain",       "age": 21, "rating": 8.5, "goals": 5,  "assists": 10, "appearances": 24],
            ["name": "Toni Kroos",          "team": "Real Madrid",        "position": "Midfielder", "nationality": "Germany",     "age": 35, "rating": 8.6, "goals": 4,  "assists": 14, "appearances": 26],
            ["name": "Declan Rice",         "team": "Arsenal",            "position": "Midfielder", "nationality": "England",     "age": 26, "rating": 8.5, "goals": 6,  "assists": 8,  "appearances": 28],
            ["name": "Bernardo Silva",      "team": "Manchester City",    "position": "Midfielder", "nationality": "Portugal",    "age": 30, "rating": 8.6, "goals": 9,  "assists": 10, "appearances": 28],
            ["name": "Luka Modric",         "team": "Real Madrid",        "position": "Midfielder", "nationality": "Croatia",     "age": 39, "rating": 8.3, "goals": 3,  "assists": 9,  "appearances": 22],
            ["name": "Joshua Kimmich",      "team": "Bayern Munich",      "position": "Midfielder", "nationality": "Germany",     "age": 30, "rating": 8.7, "goals": 5,  "assists": 14, "appearances": 28],
            ["name": "Nicolo Barella",      "team": "Inter Milan",        "position": "Midfielder", "nationality": "Italy",       "age": 28, "rating": 8.6, "goals": 7,  "assists": 11, "appearances": 28],
            ["name": "Jamal Musiala",       "team": "Bayern Munich",      "position": "Midfielder", "nationality": "Germany",     "age": 22, "rating": 8.8, "goals": 15, "assists": 12, "appearances": 30],

            // DEFENDERS
            ["name": "Virgil van Dijk",     "team": "Liverpool",          "position": "Defender",   "nationality": "Netherlands", "age": 33, "rating": 8.8, "goals": 4,  "assists": 2,  "appearances": 28],
            ["name": "Ruben Dias",          "team": "Manchester City",    "position": "Defender",   "nationality": "Portugal",    "age": 27, "rating": 8.7, "goals": 2,  "assists": 1,  "appearances": 26],
            ["name": "Ronald Araujo",       "team": "FC Barcelona",       "position": "Defender",   "nationality": "Uruguay",     "age": 26, "rating": 8.4, "goals": 3,  "assists": 1,  "appearances": 24],
            ["name": "William Saliba",      "team": "Arsenal",            "position": "Defender",   "nationality": "France",      "age": 24, "rating": 8.5, "goals": 2,  "assists": 2,  "appearances": 28],
            ["name": "Trent Alexander-Arnold","team": "Liverpool",        "position": "Defender",   "nationality": "England",     "age": 26, "rating": 8.6, "goals": 3,  "assists": 10, "appearances": 27],
            ["name": "Achraf Hakimi",       "team": "Paris Saint-Germain","position": "Defender",   "nationality": "Morocco",     "age": 26, "rating": 8.5, "goals": 4,  "assists": 8,  "appearances": 28],
            ["name": "Alessandro Bastoni",  "team": "Inter Milan",        "position": "Defender",   "nationality": "Italy",       "age": 26, "rating": 8.4, "goals": 2,  "assists": 4,  "appearances": 26],
            ["name": "Dayot Upamecano",     "team": "Bayern Munich",      "position": "Defender",   "nationality": "France",      "age": 26, "rating": 8.1, "goals": 1,  "assists": 1,  "appearances": 24],
            ["name": "Ben White",           "team": "Arsenal",            "position": "Defender",   "nationality": "England",     "age": 27, "rating": 8.2, "goals": 1,  "assists": 3,  "appearances": 25],
            ["name": "Theo Hernandez",      "team": "AC Milan",           "position": "Defender",   "nationality": "France",      "age": 27, "rating": 8.3, "goals": 5,  "assists": 6,  "appearances": 26],
            ["name": "Eder Militao",        "team": "Real Madrid",        "position": "Defender",   "nationality": "Brazil",      "age": 27, "rating": 8.3, "goals": 2,  "assists": 1,  "appearances": 22],

            // GOALKEEPERS
            ["name": "Alisson Becker",      "team": "Liverpool",          "position": "Goalkeeper", "nationality": "Brazil",      "age": 32, "rating": 8.9, "goals": 0,  "assists": 1,  "appearances": 28],
            ["name": "Ederson",             "team": "Manchester City",    "position": "Goalkeeper", "nationality": "Brazil",      "age": 31, "rating": 8.7, "goals": 0,  "assists": 2,  "appearances": 28],
            ["name": "Marc-Andre ter Stegen","team": "FC Barcelona",      "position": "Goalkeeper", "nationality": "Germany",     "age": 33, "rating": 8.6, "goals": 0,  "assists": 0,  "appearances": 26],
            ["name": "Thibaut Courtois",    "team": "Real Madrid",        "position": "Goalkeeper", "nationality": "Belgium",     "age": 33, "rating": 8.8, "goals": 0,  "assists": 0,  "appearances": 25],
            ["name": "Manuel Neuer",        "team": "Bayern Munich",      "position": "Goalkeeper", "nationality": "Germany",     "age": 39, "rating": 8.4, "goals": 0,  "assists": 0,  "appearances": 22],
            ["name": "Gianluigi Donnarumma","team": "Paris Saint-Germain","position": "Goalkeeper", "nationality": "Italy",       "age": 26, "rating": 8.7, "goals": 0,  "assists": 0,  "appearances": 28],
            ["name": "Andre Onana",         "team": "Manchester United",  "position": "Goalkeeper", "nationality": "Cameroon",    "age": 29, "rating": 7.8, "goals": 0,  "assists": 0,  "appearances": 26],
            ["name": "David Raya",          "team": "Arsenal",            "position": "Goalkeeper", "nationality": "Spain",       "age": 29, "rating": 8.3, "goals": 0,  "assists": 0,  "appearances": 26],
            ["name": "Mike Maignan",        "team": "AC Milan",           "position": "Goalkeeper", "nationality": "France",      "age": 29, "rating": 8.5, "goals": 0,  "assists": 0,  "appearances": 26],
            ["name": "Wojciech Szczesny",   "team": "Juventus",           "position": "Goalkeeper", "nationality": "Poland",      "age": 34, "rating": 8.1, "goals": 0,  "assists": 0,  "appearances": 24],
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
