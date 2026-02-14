//
//  ProfileView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/10/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataHolder: FootyHubDataHolder

    @State private var showSeedAlert: Bool = false
    @State private var showLogoutAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {

                Spacer()

                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                if let email = authManager.user?.email {
                    Text(email)
                        .font(.title3)
                        .fontWeight(.medium)
                } else {
                    Text("No email found")
                        .font(.title3)
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    showSeedAlert = true
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                        Text("Seed Sample Data")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .alert("Seed Data", isPresented: $showSeedAlert) {
                    Button("Yes, Seed Data") {
                        dataHolder.seedSampleData(context)
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will add sample teams and players to Firestore. Only do this ONCE!")
                }

                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack {
                        Image(systemName: "arrow.right.square.fill")
                        Text("Sign Out")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .alert("Sign Out", isPresented: $showLogoutAlert) {
                    Button("Sign Out", role: .destructive) {
                        dataHolder.clearLocalData(context)
                        authManager.signOut()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to sign out?")
                }

                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}
