//
//  WSManager.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 05.11.21.
//

import Foundation

// "ws://192.168.178.96:8080"
class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    private var webSocketTask: URLSessionWebSocketTask?
    private var url: String
    
    
    init(_ url: String) {
        self.url = url
        super.init()
        self.connect()
    }
    
    func connect() {
        let webSocketDelegate = WebSocket()
        let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
        self.webSocketTask = session.webSocketTask(with: URL(string: self.url)!)
        self.webSocketTask?.resume()
    }
    
    func sendMessage(msg: InfluxInlineMetric) {
        let message = URLSessionWebSocketTask.Message.string(msg.inline())
        DispatchQueue.main.async {
            self.webSocketTask?.send(message) { error in
                guard let errorMsg = error else {return}
                self.connect()
                print(errorMsg)
            }
        }
    }
}

class WebSocket: NSObject, URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
}
