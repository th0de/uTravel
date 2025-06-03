//
//  TripAdivsorListingCardView.swift
//  uTravel
//
//  Created by James Flair on 4/11/25.
//

import Foundation
import SwiftUI

struct TripAdvisorListingCardView: View {
    let model: TripAdvisorListing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.name)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            
            if let address = model.address_obj {
                HStack {
                    if let city = address.city {
                        Text(city)
                    }
                    
                    if let city = address.city, let country = address.country {
                        Text("•")
                    }
                    
                    if let country = address.country {
                        Text(country)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                if let addressString = address.address_string {
                    Text(addressString)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
