//
//  InfluxInlineMetricBuikder].swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 11.11.21.
//

import Foundation

// MARK: Builder

public class InfluxInlineMetricBuilder {
    public private(set) var measurement: String = ""
    public private(set) var tags: [String : String] = [:]
    public private(set) var fields: [String : String] = [:]
    public private(set) var timestamp: Date?
    
    public func withMeasurement(measurement: String) {
        self.measurement = measurement
    }
    
    public func addTag(_ key: String, _ value: String) {
        self.tags[key] = value
    }
    
    public func addField(_ key: String, _ value: String) {
        self.fields[key] = value
    }
    
    public func withTimestamp(_ timestamp: Date) {
        self.timestamp = timestamp
    }
    
    public func withTimestamp() {
        self.timestamp = Date.now
    }
    
    public func build() -> InfluxInlineMetric {
        assert(self.measurement != "")
        assert(!self.fields.isEmpty)
        return InfluxInlineMetric(
            measurement: self.measurement, tags: self.tags, fields: self.fields, timestamp: self.timestamp
        )
    }
    
}
