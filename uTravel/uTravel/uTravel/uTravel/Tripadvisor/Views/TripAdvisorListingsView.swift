//
//  TripAdvisorListingsView.swift
//  uTravel
//
//  Created by James Flair on 4/11/25.
//


import SwiftUI

struct TripAdvisorListingsView: View {
    @StateObject var viewModel = TripAdvisorListingsViewViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 250) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search locations, hotels, restaurants...", text: $viewModel.searchQuery)
                        .onChange(of: viewModel.searchQuery) { _ in
                            viewModel.searchChanged()
                        }
                    
                    if !viewModel.searchQuery.isEmpty {
                        Button(action: {
                            viewModel.searchQuery = ""
                            viewModel.listings = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()
                .padding()
                
                ZStack {
                    if viewModel.isLoading {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()
                            Text("Searching...")
                        }
                    }
                    
                    else if let error = viewModel.errorMessage {
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)
                                .padding()
                            
                            Text(error)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .padding()
                    }
                    
                    else if viewModel.searchQuery.isEmpty {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("Search for places on TripAdvisor")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("Type in the search box above to find locations, hotels, restaurants, and attractions")
                                .multilineTextAlignment(.center)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                    }

                    else if !viewModel.listings.isEmpty {
                        List {
                            ForEach(viewModel.listings) { listing in
                                NavigationLink(destination: TripAdvisorDetailView(model: listing)) {
                                    TripAdvisorListingCardView(model: listing)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }

                    else if !viewModel.isLoading && viewModel.errorMessage == nil {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("No results")
                        }
                    }
                }.navigationTitle("TripAdvisor")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
#Preview {
    TripAdvisorListingsView()
}
