//
//  AirbnbListingCardView.swift
//  uTravel
//
//  Created by James Flair on 1/13/25.
//

import SwiftUI

struct AirbnbListingCardView: View{
    let model: AirbnbListing
    
    var body: some View {
        VStack{
            Text(model.neighbourhood)
                .scaledToFit()
                .frame(width:100, height: 100)
            
            Text(model.name)
                .font (.title3)
                .bold()
            
            Text(model.roomType )
                .foregroundColor(.gray)
                .font(.body)
                .lineLimit(3)
                
        }
    }
}
