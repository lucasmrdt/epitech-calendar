//
//  Activity.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 12/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation

struct EpitechActivity {
    enum EventRegistration : String {
        case Registred = "registered"
        case NotRegistred(Bool)
        case Absent = "absent"
        case Present = "present"
    }
    
    var eventRegistration: EventRegistration
    var canRegister: Bool
    var isModuleAvaible: Bool
    var isModuleRegistred: Bool
    var codeModule: String
    var codeInstance: String
    var activityLabel: String
    
    var start: Date
    var end: Date
    
    var totalRegistredStudents: Int
    var maxRoomSeats: Int
    var room: String
}
