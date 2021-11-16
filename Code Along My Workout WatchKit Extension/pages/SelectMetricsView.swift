//
//  SelectMetricsView.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 14.11.21.
//

import SwiftUI

struct SelectMetricsView: View {
    
    @EnvironmentObject var setupController: SetupController
    
    var body: some View {
    
        List{
            Toggle("Raw Acceleration", isOn: $setupController.metrics.rawAcceleration)
            Toggle("Acceleration", isOn: $setupController.metrics.acceleration)
            Toggle("Gravity", isOn: $setupController.metrics.gravity)
            Toggle("Rotation Rate", isOn: $setupController.metrics.rotationRate)
            Toggle("Attitude", isOn: $setupController.metrics.attitude)
            Toggle("Gyroscope", isOn: $setupController.metrics.gyroscope)
            Toggle("Magnetic Field", isOn: $setupController.metrics.magenticField)
            
            NavigationLink(
                "Next",
                destination: SelectHzView()
            )
        }
        .navigationBarTitle("Select Metrics")
    }
}

struct SelectMetricsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectMetricsView()
    }
}
