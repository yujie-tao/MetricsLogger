//
//  SelectHzView.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 14.11.21.
//

import SwiftUI
import HealthKit

struct SelectHzView: View {
    
    @EnvironmentObject var setupController: SetupController
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack {
            if setupController.hz >= 80.0 {
                Text("High Ressource Usage!")
                    .foregroundColor(.red)
                    .font(.callout)
            }
            HStack {
                Slider(
                    value: $setupController.hz,
                    in: 10...100,
                    step: 10
                ).digitalCrownRotation($setupController.hz)
                Text("\(setupController.hz.formatted()) Hz").font(.caption)
            }
            NavigationLink(
                "Start",
                destination: CollectorView(),
                tag: HKWorkoutActivityType.walking,
                selection: $workoutManager.selectedWorkout
            )
        }
        .navigationTitle("Refresh Rate")
    }
}

struct SelectHzView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SelectHzView()
        }
    }
}
