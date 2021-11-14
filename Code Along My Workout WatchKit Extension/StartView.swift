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
                HKWorkoutActivityType.walking.name,
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

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .running:
            return "Running";
        case .cycling:
            return "Cycling";
        case .walking:
            return "Walking";
        default:
            return "Unkown Workouttype"
        }
    }
}
