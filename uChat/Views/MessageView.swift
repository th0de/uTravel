//
//  MessageView.swift
//  uTravel
//
//  Created by James Flair on 4/28/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if message.isFromCurrentUser() {
                Spacer(minLength: 50)
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(message.text)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(UIColor.systemBlue))
                        .foregroundColor(.white)
                        .clipShape(MessageBubble(isFromCurrentUser: true))
                    
                    Text(message.createdAt, style: .time)
                        .font(.caption2)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                }
                .padding(.trailing, 8)
                
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    Text(message.senderName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .padding(.leading, 12)
                    
                    Text(message.text)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .foregroundColor(Color(UIColor.label))
                        .clipShape(MessageBubble(isFromCurrentUser: false))
                    
                    Text(message.createdAt, style: .time)
                        .font(.caption2)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .padding(.leading, 12)
                }
                .padding(.leading, 8)
                
                Spacer(minLength: 50)
            }
        }
        .padding(.vertical, 4)
    }
}

struct MessageBubble: Shape {
    let isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let cornerRadius: CGFloat = 18
        
        if isFromCurrentUser {

            path.move(to: CGPoint(x: cornerRadius, y: 0))
            path.addLine(to: CGPoint(x: width - cornerRadius - 8, y: 0))
            path.addArc(center: CGPoint(x: width - cornerRadius - 8, y: cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(-90),
                       endAngle: .degrees(0),
                       clockwise: false)
            
            path.addLine(to: CGPoint(x: width - 8, y: height - cornerRadius - 10))
            path.addLine(to: CGPoint(x: width - 8, y: height - 10))
            path.addCurve(to: CGPoint(x: width, y: height),
                         control1: CGPoint(x: width - 8, y: height - 5),
                         control2: CGPoint(x: width - 4, y: height - 2))
            path.addLine(to: CGPoint(x: width - 8, y: height))
            path.addLine(to: CGPoint(x: cornerRadius, y: height))
            path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(90),
                       endAngle: .degrees(180),
                       clockwise: false)
            
            path.addLine(to: CGPoint(x: 0, y: cornerRadius))
            path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(180),
                       endAngle: .degrees(270),
                       clockwise: false)
            
        } else {

            path.move(to: CGPoint(x: width - cornerRadius, y: 0))
            path.addLine(to: CGPoint(x: cornerRadius + 8, y: 0))
            path.addArc(center: CGPoint(x: cornerRadius + 8, y: cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(-90),
                       endAngle: .degrees(180),
                       clockwise: true)
            
            path.addLine(to: CGPoint(x: 8, y: height - cornerRadius - 100))
            path.addLine(to: CGPoint(x: 8, y: height - 10))
            path.addCurve(to: CGPoint(x: 0, y: height),
                         control1: CGPoint(x: 8, y: height - 5),
                         control2: CGPoint(x: 4, y: height - 2))
            path.addLine(to: CGPoint(x: 8, y: height))
            path.addLine(to: CGPoint(x: width - cornerRadius, y: height))
            path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(90),
                       endAngle: .degrees(0),
                       clockwise: true)
            
            path.addLine(to: CGPoint(x: width, y: cornerRadius))
            path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(0),
                       endAngle: .degrees(-90),
                       clockwise: true)
        }
        
        path.closeSubpath()
        return path
    }
}

struct MessageView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(spacing: 10) {
            MessageView(message: Message(
                id: "1",
                chatId: "chat1",
                senderId: "other",
                senderName: "Joeseppe",
                text: "Yo!",
                createdAt: Date()
            ))
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}
