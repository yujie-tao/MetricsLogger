//
//  WSManager.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 05.11.21.
//

import Foundation

class WebSocketManager: NSObject, ObservableObject, URLSessionWebSocketDelegate {
    let url: String = "ws://192.168.178.96:3210/watch"
//    let url: String = "ws://169.254.97.193/watch"
    
    @Published var isConnected: Bool = false
    @Published var count: Int = 0
    
    private var webSocketTask: URLSessionWebSocketTask?
    static let shared: WebSocketManager = WebSocketManager()
    
    func connect() {
        guard !self.isConnected else {
            return
        }
        
        let webSocketDelegate = WebSocket(self)
        let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
        self.webSocketTask = session.webSocketTask(with: URL(string: self.url)!)
        self.webSocketTask?.resume()
    }
    
    func sendMessage(msg: InfluxInlineMetric) {
        guard self.isConnected else {
            return
        }
        
        let message = URLSessionWebSocketTask.Message.string(msg.inline())
        DispatchQueue.main.async {
            self.webSocketTask?.send(message) { error in
                guard let errorMsg = error else {
                    self.count += 1;
                    return
                }
                // TODO: Handle reconnection in delegate
                self.connect()
                print(errorMsg)
            }
        }
        
    }
}

// TODO: Better handle disconnect
// TODO: Implement Timer function and max reconnect
class WebSocket: NSObject, URLSessionWebSocketDelegate {
    let manager: WebSocketManager
    
    init(_ manager: WebSocketManager) {
        self.manager = manager
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
        DispatchQueue.main.async {
            self.manager.isConnected = true
        }
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
        DispatchQueue.main.async {
            self.manager.isConnected = false
        }
    }
}
