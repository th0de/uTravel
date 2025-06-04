//
//  TripAdvisorListing.swift
//  uTravel
//
//  Created by James Flair on 4/11/25.


struct TripAdvisorListing: Codable, Hashable, Identifiable {
 
    var id: String {
        return String(describing: location_id)
    }
    
    let location_id: String
    let name: String
    let address_obj: AddressObject?
    
    struct AddressObject: Codable, Hashable {
        let address_string: String?
        let city: String?
        let country: String?
        let postalcode: String?
        let state: String?
        let street1: String?
        let street2: String?
    }
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //  decoding location_id as String
        if let stringLocationId = try? container.decode(String.self, forKey: .location_id) {
            location_id = stringLocationId
        }
        //  decoding as Int and convert to String
        else if let intLocationId = try? container.decode(Int.self, forKey: .location_id) {
            location_id = String(intLocationId)
        }

        else {
            throw DecodingError.dataCorruptedError(
                forKey: .location_id,
                in: container,
                debugDescription: "location_id must be either String or Int"
            )
        }
        
        name = try container.decode(String.self, forKey: .name)
        address_obj = try container.decodeIfPresent(AddressObject.self, forKey: .address_obj)
    }
    
    enum CodingKeys: String, CodingKey {
        case location_id, name, address_obj
    }
}
