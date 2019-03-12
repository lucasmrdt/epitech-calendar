//
//  EpitechModule.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 12/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation

struct EpitechModule {
    enum ModuleStatus : String {
        case Unregistred = "notregistered"
        case Registred = "ongoing"
        case Success = "valid"
    }
    
    var id: String
    var title: String
    
    var begin: NSDate?
    var end: NSDate?
    var endRegistration: NSDate?
    var credits: Int?
}
