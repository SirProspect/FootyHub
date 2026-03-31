//
//  NewsView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/24/26.
//

import SwiftUI

struct NewsArticle: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let category: String
    let timeAgo: String
    let emoji: String
    let isBreaking: Bool
}

let sampleNews: [NewsArticle] = [
    NewsArticle(title: "Haaland Breaks Premier League Scoring Record", summary: "Erling Haaland scores his 32nd goal of the season, breaking the all-time Premier League record for goals in a single season with 8 games still to play.", category: "Premier League", timeAgo: "2h ago", emoji: "🏆", isBreaking: true),
    NewsArticle(title: "Mbappé Hat-Trick Seals El Clásico Win", summary: "Kylian Mbappé delivered a stunning hat-trick as Real Madrid defeated FC Barcelona 3-1 in a thrilling El Clásico at the Santiago Bernabéu.", category: "La Liga", timeAgo: "4h ago", emoji: "⚽", isBreaking: true),
    NewsArticle(title: "Kane Sets New Bundesliga Record", summary: "Harry Kane scored twice against Borussia Dortmund, becoming the fastest player to reach 30 Bundesliga goals in a debut season.", category: "Bundesliga", timeAgo: "6h ago", emoji: "🎯", isBreaking: false),
    NewsArticle(title: "Liverpool Advance to Champions League Final", summary: "A stunning comeback from Liverpool sees them overturn a 2-goal deficit to beat PSG 4-2 on aggregate and book their place in the Champions League final.", category: "Champions League", timeAgo: "8h ago", emoji: "🌟", isBreaking: false),
    NewsArticle(title: "Arsenal Close Gap at Top of Premier League", summary: "Arsenal's 3-0 win over Chelsea, combined with Manchester City's draw, has reduced the gap at the top of the Premier League to just 5 points.", category: "Premier League", timeAgo: "12h ago", emoji: "📊", isBreaking: false),
    NewsArticle(title: "Barcelona Star Yamal Signs New Long-Term Deal", summary: "FC Barcelona have confirmed that teenage sensation Lamine Yamal has signed a new contract keeping him at the club until 2030.", category: "Transfer News", timeAgo: "1d ago", emoji: "✍️", isBreaking: false),
    NewsArticle(title: "Bayern Munich Target Summer Rebuild", summary: "Reports from Germany suggest Bayern Munich are planning significant squad changes this summer with up to 5 new signings expected.", category: "Transfer News", timeAgo: "1d ago", emoji: "🔄", isBreaking: false),
    NewsArticle(title: "Inter Milan Clinch Serie A Title", summary: "Inter Milan were crowned Serie A champions after Napoli's defeat to AC Milan confirmed the Nerazzurri's second consecutive league title.", category: "Serie A", timeAgo: "2d ago", emoji: "🥇", isBreaking: false),
]

struct NewsView: View {
    @State private var selectedCategory = "All"
    let categories = ["All", "Premier League", "La Liga", "Bundesliga", "Serie A", "Champions League", "Transfer News"]

    private var headerDate: String {
        Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day().year())
    }

    var filtered: [NewsArticle] {
        selectedCategory == "All" ? sampleNews : sampleNews.filter { $0.category == selectedCategory }
    }

    var breakingNews: [NewsArticle] { sampleNews.filter { $0.isBreaking } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {

                    VStack(alignment: .leading, spacing: 4) {
                        Text("FootyHub")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(headerDate)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                    if !breakingNews.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 6) {
                                Circle().fill(Color.red).frame(width: 8, height: 8)
                                Text("BREAKING NEWS")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.red)
                            }

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(breakingNews) { article in
                                        BreakingNewsCard(article: article)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.red.opacity(0.05))
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { cat in
                                Button(action: { selectedCategory = cat }) {
                                    Text(cat)
                                        .font(.system(size: 13, weight: .semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 7)
                                        .background(selectedCategory == cat ? Color.blue : Color(.tertiarySystemBackground))
                                        .foregroundColor(selectedCategory == cat ? .white : .secondary)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }

                    LazyVStack(spacing: 12) {
                        ForEach(filtered) { article in
                            NewsCardView(article: article)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("News")
        }
    }
}

struct BreakingNewsCard: View {
    let article: NewsArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(article.emoji)
                .font(.system(size: 28))

            Text(article.title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(2)
                .frame(width: 200, alignment: .leading)

            Text(article.timeAgo)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.07), radius: 4)
        .frame(width: 220)
    }
}

struct NewsCardView: View {
    let article: NewsArticle

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 56, height: 56)
                Text(article.emoji)
                    .font(.system(size: 28))
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(article.category)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.blue.opacity(0.12))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())

                    Spacer()

                    Text(article.timeAgo)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                Text(article.title)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(2)

                Text(article.summary)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 2)
    }
}
