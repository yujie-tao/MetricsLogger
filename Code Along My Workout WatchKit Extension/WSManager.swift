//
//  WSManager.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 05.11.21.
//

import Foundation

// "ws://192.168.178.96:8080"
class WebSocketManager: NSObject, ObservableObject {
    var url: String
    private let jsonEncoder = JSONEncoder()
    private var webSocketTask: URLSessionWebSocketTask?
    
    
    init(_ url: String) {
        self.url = url
    }
    
    func connect() {
//        webSocketTask = urlSession.webSocketTask(with: URL(string: url)!)
        let url = URL(string: self.url)!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
    }
    
    func sendMessage(msg: Message) {
        do {
            let json = try jsonEncoder.encode(msg)
            let message = URLSessionWebSocketTask.Message.data(json)
            DispatchQueue.main.async {
                self.webSocketTask?.send(message) { error in
                    guard let errorMsg = error else {return}
                    print(errorMsg)
                }
            }
        } catch {
            print("Error encoding message")
        }
    }
    
}
