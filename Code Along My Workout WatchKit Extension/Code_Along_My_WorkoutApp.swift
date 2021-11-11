//
//  Code_Along_My_WorkoutApp.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 03.11.21.
//

import SwiftUI

@main
struct Code_Along_My_WorkoutApp: App {
    private let wsManager: WebSocketManager = WebSocketManager("ws://192.168.178.96:8080")
    @StateObject private var workoutManager: WorkoutManager = WorkoutManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
            .onAppear() {
                wsManager.connect()
                workoutManager.wsManager = wsManager
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
