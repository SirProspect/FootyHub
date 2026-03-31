//
//  SettingsView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 3/29/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var dataHolder: FootyHubDataHolder

    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("liveScoreAlerts")      private var liveScoreAlerts      = true
    @AppStorage("preferredLeague")      private var preferredLeague      = "Premier League"
    @AppStorage("displayName")          private var displayName          = ""

    @State private var showClearAlert   = false
    @State private var showSavedBanner  = false

    let leagues = ["Premier League", "La Liga", "Bundesliga", "Serie A", "Ligue 1"]

    private var headerSubtitle: String {
        Date.now.formatted(.dateTime.month(.abbreviated).day().year())
    }

    var body: some View {
        NavigationStack {
            List {

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("FootyHub")
                            .font(.headline)
                        Text(headerSubtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }

                Section(header: Text("Profile")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)

                        VStack(alignment: .leading, spacing: 3) {
                            Text(displayName.isEmpty ? "Football Fan" : displayName)
                                .font(.system(size: 16, weight: .semibold))
                            Text(authManager.user?.email ?? "")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 6)

                    HStack {
                        Label("Display Name", systemImage: "pencil")
                        Spacer()
                        TextField("Your name", text: $displayName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                            .font(.system(size: 14))
                    }
                }

                Section(header: Text("Preferences")) {
                    HStack {
                        Label("Favourite League", systemImage: "trophy.fill")
                        Spacer()
                        Picker("", selection: $preferredLeague) {
                            ForEach(leagues, id: \.self) { Text($0) }
                        }
                        .labelsHidden()
                    }

                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    .tint(.blue)

                    Toggle(isOn: $liveScoreAlerts) {
                        Label("Live Score Alerts", systemImage: "dot.radiowaves.left.and.right")
                    }
                    .tint(.blue)
                }

                Section(header: Text("App Info")) {
                    HStack {
                        Label("Version", systemImage: "info.circle.fill")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Label("Total Teams", systemImage: "shield.fill")
                        Spacer()
                        Text("\(dataHolder.teams.count)")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Label("Total Players", systemImage: "person.3.fill")
                        Spacer()
                        Text("\(dataHolder.players.count)")
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("Data")) {
                    Button(action: { showClearAlert = true }) {
                        Label("Clear Local Data", systemImage: "trash.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Clear Data", isPresented: $showClearAlert) {
                Button("Clear", role: .destructive) {
                    dataHolder.clearLocalData(context)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will remove all local teams and players. You can re-seed from Profile.")
            }
            .overlay(alignment: .top) {
                if showSavedBanner {
                    Text("✅ Settings Saved")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .cornerRadius(20)
                        .padding(.top, 10)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
    }
}
