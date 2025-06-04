//
//  TLButton.swift
//  uTravel
//
//  Created by James Flair on 1/30/25.
//

import SwiftUI

struct TLButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button{
            action()
        } label:{
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.blue)
                
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
    }
}

struct TLButton_Previews: PreviewProvider {
    static var previews: some View {
        TLButton(title: "Value",
                 background: .pink) {
            // Action
        }
    }
}
