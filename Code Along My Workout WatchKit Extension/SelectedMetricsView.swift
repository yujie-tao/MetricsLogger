//
//  SelectedMetricsView.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 14.11.21.
//

import SwiftUI

struct SelectedMetricsView: View {
    @EnvironmentObject var setupController: SetupController
    
    var body: some View {
        VStack {
            if setupController.metrics.gravity {
                Text("- Gravity")
            }
            if setupController.metrics.rawAcceleration {
                Text("- Raw Acceleration")
            }
            if setupController.metrics.rotationRate {
                Text("- Rotation Rate")
            }
            if setupController.metrics.attitude {
                Text("- Attitude")
            }
            if setupController.metrics.magenticField {
                Text("- Magnetic Field")
            }
            if setupController.metrics.gyroscope {
                Text("- Gyroscope")
            }
            if setupController.metrics.acceleration {
                Text("- Acceleration")
            }
        }
    }
}

struct SelectedMetricsView_Previews: PreviewProvider {
    static let setupController = SetupController()
    
    init() {
        SelectedMetricsView_Previews.setupController.metrics.rotationRate = true
        SelectedMetricsView_Previews.setupController.metrics.attitude = true
        SelectedMetricsView_Previews.setupController.metrics.rawAcceleration = true
    }
    
    static var previews: some View {
        SelectedMetricsView()
            .environmentObject(setupController)
    }
}
