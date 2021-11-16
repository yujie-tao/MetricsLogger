//
//  CollectableMetrics.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 14.11.21.
//

import Foundation

struct CollectableMetric {
    var rawAcceleration: Bool = false
    var attitude: Bool = false
    var rotationRate: Bool = false
    var gravity: Bool = false
    var acceleration: Bool = false
    var magenticField: Bool = false
    var gyroscope: Bool = false
}

//struct RawAcceleration: CollectableMetric {
//    let id = UUID()
//    var collect: Bool = false
//    let clearName: String = "Raw Acceleration"
//}
//
//struct Attitude: CollectableMetric {
//    let id = UUID()
//    var collect: Bool = false
//    let clearName: String = "Attitude"
//}
//
//struct RotationRate: CollectableMetric {
//    let id = UUID()
//    var collect: Bool = false
//    let clearName: String = "RotationRate"
//}
//
//struct Gravity: CollectableMetric {
//    let id = UUID()
//    var collect: Bool = false
//    let clearName: String = "Gravity"
//}
//
//struct Acceleration: CollectableMetric {
//    let id = UUID()
//    var collect: Bool = false
//    let clearName: String = "Acceleration"
//}
//
//struct MagenticField: CollectableMetric {
//    let id = UUID()
//    var collect: Bool = false
//    let clearName: String = "Magnetic Field"
//}
//
//struct Gyroscope: CollectableMetric {
//    let id = UUID()
//    var collect: Bool = false
//    var clearName: String = "Gyroscope"
//}
