//
//  Dates.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 14/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation

struct Timestamp {
    static func getDate(day: Int, month: Int, year: Int) -> Date {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return date
    }
    
    static func generateDays(forYear year: Int, forMonth month: Int) -> [Date] {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let dateRange = range.map { self.getDate(day: $0, month: month, year: year) }
        return dateRange
    }
}
