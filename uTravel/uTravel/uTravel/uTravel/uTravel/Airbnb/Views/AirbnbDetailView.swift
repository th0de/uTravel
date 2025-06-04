//
//  AirbnbDetailView.swift
//  uTravel
//
//  Created by James Flair on 1/13/25.
//

import SwiftUI

struct AirbnbDetailView: View {
    let  model:AirbnbListing
    
    var body: some View {
        ScrollView(.vertical) {
            //Info
            
            
            Text("Name:\(model.name)")
                .bold()
                .padding()
            Text("City:\(model.city)")
                .padding()
                
            
            Text("Yearly Availability: \(model.availability365.description)")

            //Host info

       
            
            
            
        }

    }
}


