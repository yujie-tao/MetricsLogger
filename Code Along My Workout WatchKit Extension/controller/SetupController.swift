//
//  SetupController.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 14.11.21.
//

import Foundation

class SetupController: ObservableObject {
    
    @Published var metrics: CollectableMetric = CollectableMetric()
    @Published var hz: Double = 10.0
    
}
