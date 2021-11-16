//
//  Code_Along_My_WorkoutApp.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 03.11.21.
//

import SwiftUI

@main
struct MetricsLoggerApp: App {
    private var setupController: SetupController = SetupController()
    private var workoutManager: WorkoutManager
    
    init() {
        workoutManager = WorkoutManager(setupController: self.setupController)
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                SelectMetricsView()
            }
            .environmentObject(workoutManager)
            .environmentObject(setupController)
            .environmentObject(WebSocketManager.shared)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
