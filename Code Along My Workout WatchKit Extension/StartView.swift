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
                HKWorkoutActivityType.other.name,
                destination: SessionPagingView(),
                tag: HKWorkoutActivityType.other,
                selection: $workoutManager.selectedWorkout
            )
            NavigationLink(
                "WS Test",
                destination: WebSocketTestView()
            )
            NavigationLink(
                "CoreMotion",
                destination: CoreMotionView()
            )
        }
        .onAppear() {
            workoutManager.requestAuthorization()
        }
//        List(workoutTypes) { workoutType in
//            NavigationLink(workoutType.name, destination: SessionPagingView(), tag: workoutType, selection: $workoutManager.selectedWorkout)
//                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
//        }
//        .listStyle(.carousel)
//        .navigationBarTitle("Workouts")
//        .onAppear {
//            workoutManager.requestAuthorization()
//        }
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
