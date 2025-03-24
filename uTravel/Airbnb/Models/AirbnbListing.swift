//
//  AirbnbListing.swift
//  uTravel
//
//  Created by James Flair on 1/13/25.
//

import Foundation

struct AirbnbListing : Codable, Hashable, Identifiable {
    let availability365: Int
    let calculatedHostListingsCount: Int
    let city: String
    let column10: Int
    let column19: String
    let column20: String
    let hostID: Int
    let id: Int
    let lastReview: String?
    let minimumNights: Int
    let name: String
    let neighbourhood: String
    let numberOfReviews: Int
    let reviewsPerMonth: Double?
    let roomType: String
    let updatedDate: String
    
    enum CodingKeys: String, CodingKey {
        case availability365 = "availability_365"
        case calculatedHostListingsCount = "calculated_host_listings_count"
        case city
        case column10 = "column_10"
        case column19 = "column_19"
        case column20 = "column_20"
        case hostID = "host_id"
        case id
        case lastReview = "last_review"
        case minimumNights = "minimum_nights"
        case name
        case neighbourhood
        case numberOfReviews = "number_of_reviews"
        case reviewsPerMonth = "reviews_per_month"
        case roomType = "room_type"
        case updatedDate = "updated_date"
    }
}


