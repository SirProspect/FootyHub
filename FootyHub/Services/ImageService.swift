//
//  ImageService.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/5/26.
//

import Foundation
import SwiftUI

class ImageService: ObservableObject {
    static let shared = ImageService()

    @Published var teamImages:   [String: URL] = [:]
    @Published var playerImages: [String: URL] = [:]

    private let base = "https://www.thesportsdb.com/api/v1/json/3"

    init() {
        let seedBadges: [String: String] = [
            // Premier League
            "Manchester City":     "https://media.api-sports.io/football/teams/50.png",
            "Liverpool":           "https://media.api-sports.io/football/teams/40.png",
            "Arsenal":             "https://media.api-sports.io/football/teams/42.png",
            "Chelsea":             "https://media.api-sports.io/football/teams/49.png",
            "Manchester United":   "https://media.api-sports.io/football/teams/33.png",
            "Tottenham Hotspur":   "https://media.api-sports.io/football/teams/47.png",
            // La Liga
            "Real Madrid":         "https://media.api-sports.io/football/teams/541.png",
            "FC Barcelona":        "https://media.api-sports.io/football/teams/529.png",
            "Atletico Madrid":     "https://media.api-sports.io/football/teams/530.png",
            "Sevilla":             "https://media.api-sports.io/football/teams/536.png",
            // Bundesliga
            "Bayern Munich":       "https://media.api-sports.io/football/teams/157.png",
            "Borussia Dortmund":   "https://media.api-sports.io/football/teams/165.png",
            "Bayer Leverkusen":    "https://media.api-sports.io/football/teams/168.png",
            // Serie A
            "Inter Milan":         "https://media.api-sports.io/football/teams/505.png",
            "AC Milan":            "https://media.api-sports.io/football/teams/489.png",
            "Juventus":            "https://media.api-sports.io/football/teams/496.png",
            "Napoli":              "https://media.api-sports.io/football/teams/492.png",
            // Ligue 1
            "Paris Saint-Germain": "https://media.api-sports.io/football/teams/85.png",
            "Olympique Marseille": "https://media.api-sports.io/football/teams/81.png",
            "Olympique Lyonnais":  "https://media.api-sports.io/football/teams/80.png",
        ]
        for (name, urlStr) in seedBadges {
            if let url = URL(string: urlStr) {
                teamImages[name] = url
            }
        }
    }

    func teamImageURL(_ name: String) -> URL? { teamImages[name] }
    func playerImageURL(_ name: String) -> URL? { playerImages[name] }

    func fetchTeamImage(_ name: String) {
        guard teamImages[name] == nil else { return }
        let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        guard let url = URL(string: "\(base)/searchteams.php?t=\(encoded)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let teams = json["teams"] as? [[String: Any]],
                  let badge = teams.first?["strTeamBadge"] as? String,
                  let imageURL = URL(string: badge) else { return }
            DispatchQueue.main.async {
                self.teamImages[name] = imageURL
            }
        }.resume()
    }

    func fetchPlayerImage(_ name: String) {
        guard playerImages[name] == nil else { return }
        let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        guard let url = URL(string: "\(base)/searchplayers.php?p=\(encoded)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let players = json["player"] as? [[String: Any]] else { return }

            let thumb  = players.first?["strThumb"]  as? String
            let cutout = players.first?["strCutout"] as? String
            let chosen = cutout ?? thumb

            guard let str = chosen, let imageURL = URL(string: str) else { return }
            DispatchQueue.main.async {
                self.playerImages[name] = imageURL
            }
        }.resume()
    }
}
