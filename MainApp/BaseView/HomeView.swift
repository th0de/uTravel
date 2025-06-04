//
//  HomeView.swift
//  uTravel
//
//  Created by James Flair on 5/17/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            VStack {
                HeaderView(title: "Home",
                           subtitle: "uTravel 2025",
                           angle: -90,
                           background: .gray)
            }
        }.navigationTitle("Home")
    }
}

#Preview {
    HomeView()
}
