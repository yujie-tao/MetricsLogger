//
//  WorkoutManager.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 03.11.21.
//

import Foundation
import HealthKit
import WatchKit

// Sekunde 40 weiter machen
// https://developer.apple.com/videos/play/wwdc2021/10009/

class WorkoutManager: NSObject, ObservableObject {
    let UUID: String = WKInterfaceDevice.current().identifierForVendor?.uuidString ?? "no-uuid"
    
    var wsManager: WebSocketManager?
    var motionManager: MotionManager = MotionManager()
    
    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout = selectedWorkout else {
                return
            }
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        // Outdoor provides more accurate location data
        configuration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle exceptions
            return
        }
        
        session?.delegate = self
        builder?.delegate = self
        
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        
        // start the workout session and begin data collecion
        let startDate = Date()
        session?.startActivity(with: startDate)
        self.motionManager.collectData(webSocketManager: self.wsManager!)
        builder?.beginCollection(withStart: startDate) { success, error in
            // workout has started
        }
    }
    
    // Request Authorization to collect data
    func requestAuthorization() {
        // needed to start workoutsessions
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // needed to read data
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            // only for activity ring
            HKQuantityType.activitySummaryType()
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            // handle error
        }
    }
    
    // MARK: - State Control
    
    // The workout session state
    @Published var running = false
    
    func pause() {
        session?.pause()
    }
    
    func resume() {
        session?.resume()
    }
    
    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }
    
    func endWorkout() {
        session?.end()
        showingSummaryView = true
    }
    
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var stepCount: Double = 0
    @Published var workout: HKWorkout?
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else {
            return
        }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                
                let iimHeartRate = InfluxInlineMetricBuilder()
                    .withMeasurement("heart_rate")
                    .addTag("uuid", self.UUID)
                    .addField("rate", "\(self.heartRate)")
                    .build()
                let iimHeartRateAverage = InfluxInlineMetricBuilder()
                    .withMeasurement("avg_heart_rate")
                    .addTag("uuid", self.UUID)
                    .addField("rate", "\(self.averageHeartRate)")
                    .build()
                self.wsManager?.sendMessage(msg: iimHeartRate)
                self.wsManager?.sendMessage(msg: iimHeartRateAverage)
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
                
                let iimActiveEnergy = InfluxInlineMetricBuilder()
                    .withMeasurement("avtive_energy")
                    .addTag("uuid", self.UUID)
                    .addField("energy", "\(self.activeEnergy)")
                    .build()
                self.wsManager?.sendMessage(msg: iimActiveEnergy)
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
                
                let iimDistance = InfluxInlineMetricBuilder()
                    .withMeasurement("distance")
                    .addTag("uuid", self.UUID)
                    .addField("meters", "\(self.distance)")
                    .build()
                self.wsManager?.sendMessage(msg: iimDistance)
            case HKQuantityType.quantityType(forIdentifier: .stepCount):
                let stepCountUnit = HKUnit.count()
                self.stepCount = statistics.sumQuantity()?.doubleValue(for: stepCountUnit) ?? 0
                
                let iimStepCount = InfluxInlineMetricBuilder()
                    .withMeasurement("step_count")
                    .addTag("uuid", self.UUID)
                    .addField("steps", "\(self.stepCount)")
                    .build()
                self.wsManager?.sendMessage(msg: iimStepCount)
            default:
                return
            }
        }
    }
    
    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        session = nil
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
    
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        // Wait for the session to transition states before ending the builder
        if toState == .ended {
            builder?.endCollection(withEnd: date) {success, error in
                self.builder?.finishWorkout() {workout, error in
                    DispatchQueue.main.async {
                        self.motionManager.stopCollectData()
                        self.workout = workout
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // handle error
    }
}

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            updateForStatistics(statistics)
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
    
    
}
