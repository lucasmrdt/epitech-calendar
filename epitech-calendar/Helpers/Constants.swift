//
//  Constants.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 07/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

struct IdentifierConstants {
    static let persistentContainerName = "epitech-calendar"

    static let activityRestorationID = "activity-restoration-id"
    static let timelineRestorationID = "timeline-restoration-id"
    static let monthRestorationID = "month-restoration-id"
}

struct Fonts {
    static let sourceSansProRegular = "SourceSansPro-Regular"
    static let sourceSansProLight = "SourceSansPro-Light"
}

struct Colors {
    static let DarkBlue = UIColor(red: 51, green: 51, blue: 81, alpha: 1)
    static let DarkBlueBg = UIColor(red: 51/255, green: 51/255, blue: 81/255, alpha: 1)
}

struct Time {
    static let numberOfMinInHour: Double = 60
}

struct ActivityConstants {
    static let numberDaysToDisplay: Double = 7
    static let beginHourOfDay: Double = 8
    static let endHourOfDay: Double = 24
    static let numberHoursByDays: Double = ActivityConstants.endHourOfDay - ActivityConstants.beginHourOfDay
    static let numberHoursToDisplay: Double = ActivityConstants.numberDaysToDisplay * ActivityConstants.numberHoursByDays
    
    // MARK - Size
    static let halfHourWidth: Double = 70
    static let hourWidth: Double = ActivityConstants.halfHourWidth * 2
    static let dayWidth: Double = ActivityConstants.hourWidth * ActivityConstants.numberHoursByDays
    static let weekWidth: Double = ActivityConstants.dayWidth * ActivityConstants.numberDaysToDisplay
    static let activityHeight: Double = 40
    static let horizontalMargin: Double = 5
    static let verticalMargin: Double = 24
}
