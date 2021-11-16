//
//  ContentView.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 03.11.21.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutTypes: [HKWorkoutActivityType] = [.cycling, .running, .walking, .other]
    
    @State var sel: HKWorkoutActivityType?

    var body: some View {
        VStack {
            NavigationLink(
                "Walk",
                destination: SessionPagingView(),
                tag: HKWorkoutActivityType.walking,
                selection: $workoutManager.selectedWorkout
            )
        }
        .onAppear() {
            workoutManager.requestAuthorization()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
