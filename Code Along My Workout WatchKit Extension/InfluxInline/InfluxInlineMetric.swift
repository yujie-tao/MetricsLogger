//
//  InfluxInlineMetric.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 11.11.21.
//

import Foundation

// MARK: InfluxInlineMetric

public struct InfluxInlineMetric {
    public let measurement: String
    public let tags: [String:String]
    public let fields: [String:String]
    public let timestamp: Date?
}
