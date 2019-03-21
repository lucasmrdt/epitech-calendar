//
//  TimelineModel.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 20/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation

struct TimelineModel {
    let date: Date
    let isSelected: Bool
    
    init(date: Date, isSelected: Bool) {
        self.date = date
        self.isSelected = isSelected
    }
}
