//
//  MetricsView.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 03.11.21.
//

import SwiftUI

struct MetricsView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date()
            )
        ) { context in
            VStack(alignment: .leading) {
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                    .foregroundColor(Color.yellow)
                Text(
                    Measurement(
                        value: workoutManager.activeEnergy,
                        unit: UnitEnergy.kilocalories
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout
                        )
                    )
                )
                Text(
                    workoutManager.heartRate.formatted(
                        .number.precision(.fractionLength(0))
                    )
                    + " bpm"
                )
                Text(
                    Measurement(
                        value: workoutManager.distance,
                        unit: UnitLength.meters
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .road
                        )
                    )
                )
            }
            .font(.system(.title, design: .rounded)
                    .monospacedDigit()
                    .lowercaseSmallCaps()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: Mode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            from: startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)).entries(from: startDate, mode: mode)
    }
}