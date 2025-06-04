//
//  AirbnbListingsView.swift
//  uTravel
//
//  Created by James Flair on 1/16/25.
//

import Foundation

final class AirbnbListingsViewViewModel: ObservableObject {
    private let service = APIService()
    
    @Published var listings: [AirbnbListing] = []
    
    public func fetchListings() {
        service.getListings { [weak self] result in
            switch result {
            case .success(let models):
                DispatchQueue.main.async {
                    
                    self?.listings = models
                }
                case.failure:
                    break
                }
            }
        }
    }

