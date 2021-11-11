//
//  CoreMotionView.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 09.11.21.
//

import SwiftUI
import CoreMotion

struct CoreMotionView: View {
    
    let motion = CMMotionManager()
    let UUID: String = WKInterfaceDevice.current().identifierForVendor?.uuidString ?? "no-uuid"
    
    @State var x: Double = 0.0
    @State var y: Double = 0.0
    @State var z: Double = 0.0
    
    @State var timer: Timer?
    
    func startAccelerometers() {
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 1.0 / 60.0
            motion.startAccelerometerUpdates()
            
            timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true) { timer in
                
                if let data = motion.accelerometerData {
                    x = data.acceleration.x
                    y = data.acceleration.y
                    z = data.acceleration.z
                    
                    sendData(x: x, y: y, z: z)
                }
            }
            
            RunLoop.current.add(timer!, forMode: .default)
        }
    }
    
    func sendData(x: Double, y: Double, z: Double) {
        let url = URL(string: "http://192.168.178.96:8086/api/v2/write?bucket=watch/autogen")!
        
        var req = URLRequest(url: url)
        let body: Data! = "acc,uuid=\(UUID) x=\(x),y=\(y),z=\(z)".data(using: .utf8)
        req.httpMethod = "POST"
        req.httpBody = body
        req.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
        
        let task = URLSession.shared.dataTask(with: req)
        task.resume()
        
    }
    
    var body: some View {
        VStack {
            Text("X: \(x)")
            Text("Y: \(y)")
            Text("Z: \(z)")
        }.onAppear() {
            startAccelerometers()
        }
    }
}

struct CoreMotionView_Previews: PreviewProvider {
    static var previews: some View {
        CoreMotionView()
    }
}
