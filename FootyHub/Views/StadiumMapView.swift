//
//  StadiumMapView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/24/26.
//

import SwiftUI
import MapKit

struct StadiumLocation: Identifiable {
    let id = UUID()
    let name: String
    let team: String
    let city: String
    let country: String
    let capacity: Int
    let coordinate: CLLocationCoordinate2D
}

let sampleStadiums: [StadiumLocation] = [
    StadiumLocation(name: "Spotify Camp Nou",    team: "FC Barcelona",        city: "Barcelona",       country: "Spain",   capacity: 99354, coordinate: CLLocationCoordinate2D(latitude: 41.3809, longitude: 2.1228)),
    StadiumLocation(name: "Santiago Bernabéu",   team: "Real Madrid",         city: "Madrid",          country: "Spain",   capacity: 81044, coordinate: CLLocationCoordinate2D(latitude: 40.4530, longitude: -3.6883)),
    StadiumLocation(name: "Etihad Stadium",      team: "Manchester City",     city: "Manchester",      country: "England", capacity: 53400, coordinate: CLLocationCoordinate2D(latitude: 53.4831, longitude: -2.2004)),
    StadiumLocation(name: "Anfield",             team: "Liverpool",           city: "Liverpool",       country: "England", capacity: 61276, coordinate: CLLocationCoordinate2D(latitude: 53.4308, longitude: -2.9608)),
    StadiumLocation(name: "Parc des Princes",    team: "Paris Saint-Germain", city: "Paris",           country: "France",  capacity: 47929, coordinate: CLLocationCoordinate2D(latitude: 48.8414, longitude: 2.2530)),
    StadiumLocation(name: "Allianz Arena",       team: "Bayern Munich",       city: "Munich",          country: "Germany", capacity: 75024, coordinate: CLLocationCoordinate2D(latitude: 48.2188, longitude: 11.6247)),
    StadiumLocation(name: "Allianz Stadium",     team: "Juventus",            city: "Turin",           country: "Italy",   capacity: 41507, coordinate: CLLocationCoordinate2D(latitude: 45.1096, longitude: 7.6413)),
    StadiumLocation(name: "Chase Stadium",       team: "Inter Miami",         city: "Fort Lauderdale", country: "USA",     capacity: 21550, coordinate: CLLocationCoordinate2D(latitude: 26.1916, longitude: -80.1406)),
]

struct StadiumMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.0, longitude: 8.0),
        span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
    )
    @State private var selectedStadium: StadiumLocation? = nil

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region, annotationItems: sampleStadiums) { stadium in
                    MapAnnotation(coordinate: stadium.coordinate) {
                        Button(action: {
                            withAnimation { selectedStadium = stadium }
                        }) {
                            VStack(spacing: 2) {
                                Image(systemName: "building.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(selectedStadium?.id == stadium.id ? Color.orange : Color.blue)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)

                                Text(stadium.team)
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)

                if let stadium = selectedStadium {
                    NavigationLink(destination: StadiumDetailView(stadium: stadium)) {
                        StadiumCardView(stadium: stadium)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationTitle("Stadiums")
        }
    }
}

struct StadiumCardView: View {
    let stadium: StadiumLocation

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "building.2.fill")
                .font(.system(size: 32))
                .foregroundColor(.blue)
                .frame(width: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(stadium.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(stadium.team)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(stadium.city), \(stadium.country)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(stadium.capacity / 1000)K")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("capacity")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}
