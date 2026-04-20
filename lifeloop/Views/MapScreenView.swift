//
//  MapScreenView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/14/26.
//

import SwiftUI
import MapKit
import CoreLocation

extension Place {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapScreenView: View {
    @StateObject private var viewModel = LocationViewModel()
    @State private var selectedPlace: Place?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Map(position: .constant(.region(viewModel.region))) {
                    if let userCoordinate = viewModel.userCoordinate {
                        Annotation("You", coordinate: userCoordinate) {
                            Image(systemName: "person.circle.fill")
                                .foregroundStyle(.blue)
                                .font(.title2)
                        }
                    }

                    ForEach(viewModel.places) { place in
                        Annotation(place.name, coordinate: place.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(.red)
                                .font(.title2)
                        }
                    }
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                if viewModel.isLoading {
                    Text("Loading nearby places...")
                        .foregroundStyle(.secondary)
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                }

                if let selectedPlace {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Selected Location")
                            .font(.headline)

                        Text(selectedPlace.name)
                            .font(.title3)
                            .bold()

                        Text(selectedPlace.countryName ?? "Unknown Country")
                            .foregroundStyle(.secondary)

                        Text("Population: \(selectedPlace.population ?? 0)")
                            .font(.caption)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Text("Nearby Places")
                    .font(.headline)

                if viewModel.places.isEmpty && !viewModel.isLoading {
                    Text("No nearby places to show.")
                        .foregroundStyle(.secondary)
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.places) { place in
                            Button {
                                selectedPlace = place
                                viewModel.region = MKCoordinateRegion(
                                    center: place.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
                                )
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(place.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text(place.countryName ?? "Unknown Country")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    Text("Population: \(place.population ?? 0)")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.gray.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Nearby Locations")
        .onAppear {
            viewModel.requestLocationAccess()
        }
    }
}
