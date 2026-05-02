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

    var filteredPlaces: [Place] {
        viewModel.filteredPlaces()
    }

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

                    ForEach(filteredPlaces) { place in
                        Annotation(place.name, coordinate: place.coordinate) {
                            Image(systemName: iconName(for: place.category))
                                .foregroundStyle(colorForCategory(place.category))
                                .font(.title2)
                                .onTapGesture {
                                    selectedPlace = place
                                }
                        }
                    }
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 6) {
                    Text("Nearby Growth Places")
                        .font(.headline)

                    Text("Shows parks, libraries, and fitness centers near your current location.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Picker("Category", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.categoryOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)

                if viewModel.isLoading {
                    Text("Loading nearby growth places...")
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

                        Text(selectedPlace.displayCategory)
                            .foregroundStyle(.secondary)

                        Button("Open in Apple Maps") {
                            openInMaps(place: selectedPlace)
                        }
                        .font(.subheadline)
                        .padding(.top, 4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                HStack {
                    Text("Results")
                        .font(.headline)

                    Spacer()

                    Text("\(filteredPlaces.count) found")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if filteredPlaces.isEmpty && !viewModel.isLoading {
                    Text("No places found for this filter.")
                        .foregroundStyle(.secondary)
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(filteredPlaces) { place in
                            Button {
                                selectedPlace = place
                                viewModel.region = MKCoordinateRegion(
                                    center: place.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                                )
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: iconName(for: place.category))
                                        .font(.title2)
                                        .foregroundStyle(colorForCategory(place.category))
                                        .frame(width: 30)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(place.name)
                                            .font(.headline)
                                            .foregroundStyle(.primary)

                                        Text(place.displayCategory)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
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
        .navigationTitle("Growth Map")
        .onAppear {
            viewModel.requestLocationAccess()
        }
    }

    private func iconName(for category: String) -> String {
        if category == "park" {
            return "leaf.fill"
        } else if category == "library" {
            return "books.vertical.fill"
        } else if category == "fitness" {
            return "figure.strengthtraining.traditional"
        } else {
            return "mappin.circle.fill"
        }
    }

    private func colorForCategory(_ category: String) -> Color {
        if category == "park" {
            return .green
        } else if category == "library" {
            return .purple
        } else if category == "fitness" {
            return .orange
        } else {
            return .red
        }
    }

    private func openInMaps(place: Place) {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
        item.name = place.name
        item.openInMaps()
    }
}
