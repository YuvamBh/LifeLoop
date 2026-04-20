//
//  MapScreenView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//


import SwiftUI
import MapKit

struct MapScreenView: View {
    @StateObject private var viewModel = LocationViewModel()
    @State private var selectedPlace: Place?

    var body: some View {
        VStack {
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
                            .onTapGesture {
                                selectedPlace = place
                            }
                    }
                }
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()

            if let selectedPlace {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedPlace.name)
                        .font(.headline)

                    Text(selectedPlace.countryName ?? "Unknown Country")
                        .foregroundStyle(.secondary)

                    Text("Population: \(selectedPlace.population ?? 0)")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }

            List(viewModel.places) { place in
                Button {
                    selectedPlace = place
                    viewModel.region = MKCoordinateRegion(
                        center: place.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                    )
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(place.name)
                            .font(.headline)

                        Text(place.countryName ?? "Unknown Country")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Population: \(place.population ?? 0)")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .navigationTitle("Nearby Growth Locations")
        .onAppear {
            viewModel.requestLocationAccess()
        }
    }
}