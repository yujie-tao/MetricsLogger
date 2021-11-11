//
//  WebSocketTestView.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 05.11.21.
//

import SwiftUI

struct WebSocketTestView: View {
    
    let manager: WebSocketManager = WebSocketManager("ws://192.168.178.96:8080")
    
    var body: some View {
        Button("Send", action: sendMessage)
    }
    
    func sendMessage() {
        manager.sendMessage(msg: Message(value: "Test1"))
    }
}

struct WebSocketTestView_Previews: PreviewProvider {
    static var previews: some View {
        WebSocketTestView()
    }
}
