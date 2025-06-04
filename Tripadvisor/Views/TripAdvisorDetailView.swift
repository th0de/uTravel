//
//  TripAdvisorDetailView.swift
//  uTravel
//
//  Created by James Flair on 4/11/25.
//

import SwiftUI
import MapKit

struct TripAdvisorDetailView: View {
    let model: TripAdvisorListing
    @State private var region: MKCoordinateRegion?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(model.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Divider()
                
                if let address = model.address_obj {
                    Group {
                        Text("Location Details")
                            .font(.headline)
                            .padding(.horizontal)

                        if let addressString = address.address_string {
                            HStack(alignment: .top) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                                
                                Text(addressString)
                                    .font(.body)
                            }
                            .padding(.horizontal)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            if let city = address.city {
                                LabeledContent("City", value: city)
                            }
                            
                            if let state = address.state {
                                LabeledContent("State/Province", value: state)
                            }
                            
                            if let country = address.country {
                                LabeledContent("Country", value: country)
                            }
                            
                            if let postalcode = address.postalcode {
                                LabeledContent("Postal Code", value: String(describing: postalcode))
                            }
                        }
                        .padding(.horizontal)
                        
                        if let addressString = address.address_string {
                            let encodedAddress = addressString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            let mapUrl = URL(string: "http://maps.apple.com/?address=\(encodedAddress)")
                            
                            if let url = mapUrl {
                                Link(destination: url) {
                                    HStack {
                                        Image(systemName: "map.fill")
                                        Text("Open in Maps")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                
                Divider()
                
                let tripAdvisorUrl = URL(string: "https://www.tripadvisor.com/\(model.location_id)")
                if let url = tripAdvisorUrl {
                    Link(destination: url) {
                        HStack {
                            Image(systemName: "globe")
                            Text("View on TripAdvisor")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Helper view for labeled content
    private func LabeledContent(_ label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .fontWeight(.medium)
        }
    }
}
