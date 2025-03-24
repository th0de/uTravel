//
//  AirBnbListingView.swift
//  uTravel
//
//  Created by James Flair on 1/13/25.
//

import SwiftUI

struct AirbnbListingsVeiw: View {
    @StateObject var viewModel = AirbnbListingsViewViewModel()
    var body: some View {
        NavigationView {
            VStack{
                if viewModel.listings.isEmpty{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    List(viewModel.listings) { listing in
                        NavigationLink(destination: AirbnbDetailView(model:listing), label: {
                            AirbnbListingCardView(model: listing)
                        })
                        .navigationTitle("Airbnb")
                    }
                }
            }
        }
        .onAppear{
            viewModel.fetchListings()
        }
    }
}

#Preview {
    AirbnbListingsVeiw()
}
