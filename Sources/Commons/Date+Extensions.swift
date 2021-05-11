//
//  Date+Extensions.swift
//
//  Created by Klajd Deda on 7/28/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import Foundation

public extension Date {
    func string(withDateFormat dateFormat: String) -> String {
        let formatter = DateFormatter()
        
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: self)
    }

    // https://nshipster.com/formatter/
    var relativeDateString: String {
        if abs(self.timeIntervalSince(Date())) > 24*3600*7 {
            // older than a week
            return "Updated a while back"
        }

        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: self, relativeTo: Date())
        return "Updated less than \(relativeDate)"
    }

    var elapsedInMSWith3Digits: String {
        (Date().timeIntervalSince(self) * 1000.0).with3Digits
    }
}

