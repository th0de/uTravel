//
//  TripAdvisorListingsViewViewModel.swift
//  uTravel
//
//  Created by James Flair on 4/11/25.
//

import Foundation
import SwiftUI

final class TripAdvisorListingsViewViewModel: ObservableObject {
    private let service = TripAPIService()
    
    @Published var searchQuery: String = ""
    @Published var listings: [TripAdvisorListing] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var searchDebounceTimer: Timer?
    
    public func searchChanged() {
  
        searchDebounceTimer?.invalidate()
        errorMessage = nil
        
        if searchQuery.isEmpty {
            listings = []
            return
        }
        
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.fetchListings()
        }
    }
    
    public func fetchListings() {

        guard !searchQuery.isEmpty else {
            listings = []
            return
        }
        isLoading = true
        errorMessage = nil
        
        service.getListings(searchQuery: searchQuery) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let listings):
                    self?.listings = listings
                    
                    if listings.isEmpty {
                        self?.errorMessage = "No results found for '\(self?.searchQuery ?? "")'"
                    }
                    
                case .failure(let error):
                    self?.listings = []
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                    print("Failed to fetch listings: \(error)")
                }
            }
        }
    }
}
