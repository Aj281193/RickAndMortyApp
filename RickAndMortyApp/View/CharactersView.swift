//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by Ashish Jaiswal on 26/10/26.
//

import SwiftUI

struct CharactersView: View {
    @State private var pageNumber = 20
    var body: some View {
        NavigationStack {
            List(0..<10) {_ in
                HStack(spacing: 8) {
                    Image(systemName: "heart.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("Morty")
                            .font(.headline)
                        Text("Number of Episode: \(pageNumber)")
                            .font(.subheadline)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Characters")
        }
    }
}

#Preview {
    CharactersView()
}
