//
//  ContentView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                CommunityFeedView()
            }
            .tabItem {
                Label("Community", systemImage: "person.2")
            }

            NavigationStack {
                MapScreenView()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
        .preferredColorScheme(.dark)
        .tint(.mint)
        .fontDesign(.rounded)
    }
}







