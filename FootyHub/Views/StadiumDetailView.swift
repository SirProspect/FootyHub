//
//  StadiumDetailView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/24/26.
//

import SwiftUI
import MapKit

struct StadiumDetailView: View {
    let stadium: StadiumLocation

    @State private var region: MKCoordinateRegion

    init(stadium: StadiumLocation) {
        self.stadium = stadium
        _region = State(initialValue: MKCoordinateRegion(
            center: stadium.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                Map(coordinateRegion: $region, annotationItems: [stadium]) { s in
                    MapAnnotation(coordinate: s.coordinate) {
                        VStack(spacing: 2) {
                            Image(systemName: "building.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                }
                .frame(height: 220)
                .disabled(true)

                VStack(spacing: 20) {

                    VStack(spacing: 8) {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)

                        Text(stadium.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        Text(stadium.team)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    Divider()

                    VStack(spacing: 14) {
                        Text("Stadium Info")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        InfoRow(label: "Team",     value: stadium.team)
                        InfoRow(label: "City",     value: stadium.city)
                        InfoRow(label: "Country",  value: stadium.country)
                        InfoRow(label: "Capacity", value: stadium.capacity.formatted() + " seats")
                    }
                    .padding(.horizontal)

                    Divider()

                    VStack(spacing: 10) {
                        Text("Capacity Scale")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        let maxCapacity = 100_000.0
                        let ratio = Double(stadium.capacity) / maxCapacity

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("\(stadium.capacity.formatted()) seats")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(String(format: "%.0f%% of 100K", ratio * 100))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.blue.opacity(0.15))
                                        .frame(height: 14)
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.blue)
                                        .frame(width: geo.size.width * ratio, height: 14)
                                }
                            }
                            .frame(height: 14)
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 30)
                }
            }
        }
        .navigationTitle(stadium.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
