//
//  ControlsView.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 03.11.21.
//

import SwiftUI

struct ControlsView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        HStack() {
            VStack {
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(Color.red)
                .font(.title2)
                Text("End")
            }
            VStack {
                Button {
                    workoutManager.togglePause()
                } label: {
                    Image(systemName: workoutManager.running ? "pause" : "play")
                }
                .tint(Color.yellow)
                .font(.title2)
                Text(workoutManager.running ? "Pause" : "Resume")
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}
