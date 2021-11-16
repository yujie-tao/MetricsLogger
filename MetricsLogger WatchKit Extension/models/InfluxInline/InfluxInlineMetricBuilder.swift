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
    
    public func withMeasurement(_ measurement: String) -> InfluxInlineMetricBuilder {
        self.measurement = measurement
        return self
    }
    
    public func addTag(_ key: String, _ value: String) -> InfluxInlineMetricBuilder {
        self.tags[key] = value
        return self
    }
    
    public func addField(_ key: String, _ value: String) -> InfluxInlineMetricBuilder {
        self.fields[key] = value
        return self
    }
    
    public func withTimestamp(_ timestamp: Date) -> InfluxInlineMetricBuilder {
        self.timestamp = timestamp
        return self
    }
    
    public func withTimestamp() -> InfluxInlineMetricBuilder {
        self.timestamp = Date.now
        return self
    }
    
    public func build() -> InfluxInlineMetric {
        assert(self.measurement != "")
        assert(!self.fields.isEmpty)
        return InfluxInlineMetric(
            measurement: self.measurement, tags: self.tags, fields: self.fields, timestamp: self.timestamp
        )
    }
    
}
