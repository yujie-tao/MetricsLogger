//
//  CollectorView.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 14.11.21.
//

import SwiftUI

struct CollectorView: View {
    
    @State private var selection: Tab = .overview
    
    enum Tab {
        case controls
        case overview
        case selectedMetrics
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            Overview().tag(Tab.overview)
            SelectedMetricsView().tag(Tab.selectedMetrics)
        }
        .navigationTitle("Collecting Data")
    }
}

private struct Overview: View {
    @EnvironmentObject var setupController: SetupController
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        TimelineView(
            OverviewTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date()
            )
        ) { context in
            VStack {
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                    .foregroundColor(Color.yellow)
                Text(webSocketManager.url)
                Text("Connected: \(webSocketManager.isConnected ? "True" : "False")")
                Text("Refresh Rate: \(setupController.hz.formatted()) Hz")
                Text("Count: \(webSocketManager.count)")
            }
        }
    }
}

private struct OverviewTimelineSchedule: TimelineSchedule {
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: Mode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            from: startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)).entries(from: startDate, mode: mode)
    }
}

struct CollectorView_Previews: PreviewProvider {
    static let setupController: SetupController = SetupController()
    static let workoutManager: WorkoutManager = WorkoutManager(setupController: CollectorView_Previews.setupController)
    
    static var previews: some View {
        CollectorView()
            .environmentObject(workoutManager)
            .environmentObject(setupController)
    }
}

struct Overview_Preview: PreviewProvider {
    
    static let setupController: SetupController = SetupController()
    
    static var previews: some View {
        Overview()
            .environmentObject(setupController)
    }
}
