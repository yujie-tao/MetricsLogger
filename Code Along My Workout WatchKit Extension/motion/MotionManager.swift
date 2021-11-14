//
//  MotionManager.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 12.11.21.
//

import Foundation
import CoreMotion
import WatchKit

class MotionManager {
    
    let motion = CMMotionManager()
    let UUID: String = WKInterfaceDevice.current().identifierForVendor?.uuidString ?? "no-uuid"
    
    private let baseMetricBuilder: InfluxInlineMetricBuilder!
    
    var timer: Timer?
    var webSocketManager: WebSocketManager?
    
    init() {
        baseMetricBuilder = InfluxInlineMetricBuilder().addTag("uuid", self.UUID)
    }
    
    func collectData(webSocketManager: WebSocketManager) {
        self.webSocketManager = webSocketManager
        let interval = 1.0 / 10.0
        
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = interval
            motion.startAccelerometerUpdates()
        }
        
        if motion.isGyroAvailable {
            motion.gyroUpdateInterval = interval
            motion.startGyroUpdates()
        }
        
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = interval
            motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
        }
        
        timer = Timer(fire: Date(), interval: interval, repeats: true) { timer in
            self.handleAccelerationData()
            self.handleDeviceMotionGyroscope()
            self.handleDeviceMotionAcceleration()
        }
        
        RunLoop.current.add(timer!, forMode: .default)
    }
    
    // MARK: Handle Acc Data
    func handleAccelerationData() {
        if let data = self.motion.accelerometerData {
            
            let iimAccData = InfluxInlineMetricBuilder()
                .withMeasurement("acceleration")
                .addTag("uuid", self.UUID)
                .addTag("unbiased", "true")
                .addField("x", "\(data.acceleration.x)")
                .addField("y", "\(data.acceleration.y)")
                .addField("z", "\(data.acceleration.z)")
                .build()
            
            self.webSocketManager?.sendMessage(msg: iimAccData)
        }
    }
    
    // MARK: Unbiased (DeviceMotion)
    
    
    
    
    
    // MARK: Handle Attitude
    func handleAttitude() {
        if let data = self.motion.deviceMotion?.attitude {
            let iimAttitude = baseMetricBuilder
                .withMeasurement("attitude")
                .addTag("unbiased", "true")
                .addField("yaw", "\(data.yaw)")
                .addField("pitch", "\(data.pitch)")
                .addField("roll", "\(data.roll)")
                .addField("rotation_matrix", "\(data.rotationMatrix)")
                .build()
            let iimQuaternion = baseMetricBuilder
                .withMeasurement("attitude_quaternion")
                .addTag("unbiased", "true")
                .addField("x", "\(data.quaternion.x)")
                .addField("x", "\(data.quaternion.y)")
                .addField("x", "\(data.quaternion.z)")
                .addField("x", "\(data.quaternion.w)")
                .build()
            let iimRotationMatrix = baseMetricBuilder
                .withMeasurement("attitude_quaternion")
                .addTag("unbiased", "true")
                .addField("11", "\(data.rotationMatrix.m11)")
                .addField("12", "\(data.rotationMatrix.m12)")
                .addField("13", "\(data.rotationMatrix.m13)")
                .addField("21", "\(data.rotationMatrix.m21)")
                .addField("22", "\(data.rotationMatrix.m22)")
                .addField("23", "\(data.rotationMatrix.m23)")
                .addField("31", "\(data.rotationMatrix.m31)")
                .addField("32", "\(data.rotationMatrix.m32)")
                .addField("33", "\(data.rotationMatrix.m33)")
                .build()
            webSocketManager?.sendMessage(msg: iimAttitude)
            webSocketManager?.sendMessage(msg: iimQuaternion)
            webSocketManager?.sendMessage(msg: iimRotationMatrix)
        }
    }
    
    // MARK: Handle Rotation Rate
    func handleRotationRate() {
        if let data = self.motion.deviceMotion?.rotationRate {
            let iimRotationRate = baseMetricBuilder
                .withMeasurement("rotation_rate")
                .addTag("unbiased", "true")
                .addField("x", "\(data.x)")
                .addField("y", "\(data.y)")
                .addField("z", "\(data.z)")
                .build()
            webSocketManager?.sendMessage(msg: iimRotationRate)
        }
    }
    
    // MARK: Handle Gravity
    func handleGravity() {
        if let data = self.motion.deviceMotion?.gravity {
            let iimGravity = baseMetricBuilder
                .withMeasurement("gravity")
                .addTag("unbiased", "true")
                .addField("x", "\(data.x)")
                .addField("y", "\(data.y)")
                .addField("z", "\(data.z)")
                .build()
            webSocketManager?.sendMessage(msg: iimGravity)
        }
    }
    
    // MARK: Acceleration
    func handleDeviceMotionAcceleration() {
        if let data = self.motion.deviceMotion {
            let iimAccData = InfluxInlineMetricBuilder()
                .withMeasurement("acceleration")
                .addTag("uuid", self.UUID)
                .addTag("unbiased", "true")
                .addField("x", "\(data.userAcceleration.x)")
                .addField("y", "\(data.userAcceleration.y)")
                .addField("z", "\(data.userAcceleration.z)")
                .build()
            
            self.webSocketManager?.sendMessage(msg: iimAccData)
        }
    }
    
    // MARK: Handle Magnetic Field
    func handleMagneticField() {
        if let data = self.motion.deviceMotion?.magneticField {
            let iimMagenticField = baseMetricBuilder
                .withMeasurement("magnetic_field")
                .addTag("unbiased", "true")
                .addTag("accuracy", "\(data.accuracy.rawValue)")
                .addField("x", "\(data.field.x)")
                .addField("y", "\(data.field.y)")
                .addField("z", "\(data.field.z)")
                .build()
            webSocketManager?.sendMessage(msg: iimMagenticField)
        }
    }
    
    // MARK: Handle Heading
    func handleHeading() {
        if let data = self.motion.deviceMotion?.heading {
            let iimHeading = baseMetricBuilder
                .withMeasurement("heading")
                .addTag("unbiased", "true")
                .addField("degree", "\(data)")
                .build()
            webSocketManager?.sendMessage(msg: iimHeading)
        }
    }
    
    // MARK: Unbiased Gyroscope
    func handleDeviceMotionGyroscope() {
        if let data = self.motion.deviceMotion {
            let iimAcceleration = InfluxInlineMetricBuilder()
                .withMeasurement("gyroscope")
                .addTag("uuid", self.UUID)
                .addTag("unbiased", "true")
                .addField("x", "\(data.rotationRate.x)")
                .addField("y", "\(data.rotationRate.y)")
                .addField("z", "\(data.rotationRate.z)")
                .build()
            webSocketManager?.sendMessage(msg: iimAcceleration)
        }
    }
    
    
    // MARK: Cleanup
    func stopCollectData() {
        self.timer?.invalidate()
        self.motion.stopGyroUpdates()
        self.motion.stopAccelerometerUpdates()
        self.motion.stopDeviceMotionUpdates()
    }
}
