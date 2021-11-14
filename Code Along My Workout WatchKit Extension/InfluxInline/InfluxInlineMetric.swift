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
    
    /*
         * Get the point's tags as a key=value string
         * @return string of comma-separataed key=value pairs
         */
        public func getTagsString() -> String {
            var tagString = ""
            for (key, value) in self.tags {
                tagString = "\(tagString)\(key)=\(value),"
            }
            tagString.removeLast()
            return tagString
        }
        
        /*
         * Get the point's data values
         * @return comma-separated key=value pairs
         */
        public func getFieldsString() -> String {
            var valString = " "
            for (key, value) in self.fields {
                valString = "\(valString)\(key)=\(value),"
            }
            valString.removeLast()
            return valString
        }
    
    
    func inline() -> String {
        assert(self.measurement != "")
        assert(!self.fields.isEmpty)
        
        return "\(measurement),\(getTagsString())\(getFieldsString())"
    }
}


