//
//  Message.swift
//  Code Along My Workout WatchKit Extension
//
//  Created by Justin Vietz on 05.11.21.
//

import Foundation
import WatchKit


struct Message: Codable {
    var UUID: String = WKInterfaceDevice.current().identifierForVendor?.uuidString ?? "no-uuid"
    var value: String
}
