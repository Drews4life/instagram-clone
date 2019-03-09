//
//  HelperExtensions.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/9/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation

extension Date {
    func timeAgo() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minutes = 60
        let hour = 60 * minutes
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minutes {
            quotient = secondsAgo
            unit = "seconds"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minutes
            unit = "minutes"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
}
