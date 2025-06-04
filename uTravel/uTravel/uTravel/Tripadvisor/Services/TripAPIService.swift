//
//  APIService.swift
//  uTravel
//
//  Created by James Flair on 4/11/25.
//
import SwiftUI
import Foundation
    
final class TripAPIService {
    @AppStorage("tripadvisor_api_key") var apiKey1 = ""
    struct Constants {
        static let apiUrl = URL(string:"https://api.content.tripadvisor.com/api/v1/location/search")
    }
    
    public func getListings(searchQuery: String, completion: @escaping (Result<[TripAdvisorListing], Error>) -> Void) {
        guard var urlComponents = URLComponents(url: Constants.apiUrl!, resolvingAgainstBaseURL: false) else {
            completion(.failure(NSError(domain: "TripAPIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        

        urlComponents.queryItems = [
            URLQueryItem(name: "searchQuery", value: searchQuery),
            URLQueryItem(name: "key", value: apiKey1)
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "TripAPIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL"])))
            return
        }
        
        print("Fetching from URL: \(url)")
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Network error: \(error)")
                completion(.failure(error))
                return
            }
  
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "TripAPIService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "TripAPIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "TripAPIService", code: 3, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw API Response: \(jsonString)")
                }
                
                let response = try JSONDecoder().decode(TripAdvisorResponse.self, from: data)
                completion(.success(response.data))
            } catch {
                print("Decoding error: \(error)")
                
                if let json = try? JSONSerialization.jsonObject(with: data) {
                    print("JSON Response: \(json)")
                }
                
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}
