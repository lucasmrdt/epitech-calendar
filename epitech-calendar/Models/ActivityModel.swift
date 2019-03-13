//
//  Activity.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 12/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation

struct Activity : Decodable {
    
    // MARK - Enumeration
    enum EventRegistration : String {
        case Registred = "registered"
        case Absent = "absent"
        case Present = "present"
        case Unregistred = "unregistred"  // Is a boolean on return API :(
    }
    
    enum CodingKeys: String, CodingKey {
        case eventRegistration = "event_registered"
        case canRegister = "allow_register"
        case isModuleAvaible = "module_available"
        case isModuleRegistred = "module_registered"
        case codeModule = "codemodule"
        case codeInstance = "codeinstance"
        case activityLabel = "acti_title"
        case totalRegistredStudents = "total_students_registered"
        case start, end, semester
    }
    
    enum LocationKeys: String, CodingKey {
        case location = "room"
    }
    
    enum CodingRoomKeys: String, CodingKey {
        case maxRoomSeats = "seats"
        case location = "code"
    }
    
    // MARK - Attributes
    let eventRegistration: EventRegistration
    let canRegister: Bool
    let isModuleAvaible: Bool
    let isModuleRegistred: Bool
    let codeModule: String
    let codeInstance: String
    let activityLabel: String
    let semester: Int
    
    let start: Date
    let end: Date
    
    let totalRegistredStudents: Int
    let maxRoomSeats: Int
    let location: String
    
    
    // MARK - Static Functions
    private static func getEventRegistration(values: KeyedDecodingContainer<CodingKeys>) -> EventRegistration {
        do {
            let eventRegistrationRawValue = try values.decode(String.self, forKey: .eventRegistration)
            return EventRegistration(rawValue: eventRegistrationRawValue)!
        } catch {
            // Catch only when eventRegistration == Bool(false), when user is unregistred
            return EventRegistration.Unregistred
        }
    }
    
    private static func getCampus(from campus: String) -> String {
        switch campus {
        case "Jardin-Public":
            return "J-P"
        case "St-Louis":
            return "S-L"
        default:
            return "Unknown"
        }
    }
    
    private static func getRoom(from room: String) -> String {
        return room.replacingOccurrences(of: "-", with: " ")
    }
    
    private static func getLocation(values: KeyedDecodingContainer<CodingRoomKeys>) throws -> String? {
        let rawRoom = try values.decode(String.self, forKey: .location)
        let roomPieces = rawRoom.split(separator: "/")
        guard roomPieces.count >= 4 else { return nil }
        let campus = Activity.getCampus(from: String(roomPieces[2]))
        let room = getRoom(from: String(roomPieces[3]))
        return "\(campus) \(room)"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        canRegister = try values.decode(Bool.self, forKey: .canRegister)
        isModuleAvaible = try values.decode(Bool.self, forKey: .isModuleAvaible)
        isModuleRegistred = try values.decode(Bool.self, forKey: .isModuleRegistred)
        codeModule = try values.decode(String.self, forKey: .codeModule)
        codeInstance = try values.decode(String.self, forKey: .codeInstance)
        activityLabel = try values.decode(String.self, forKey: .activityLabel)
        totalRegistredStudents = try values.decode(Int.self, forKey: .totalRegistredStudents)
        start = try values.decode(Date.self, forKey: .start)
        end = try values.decode(Date.self, forKey: .end)
        semester = try values.decode(Int.self, forKey: .semester)
        eventRegistration = Activity.getEventRegistration(values: values)

        let locationBlock = try decoder.container(keyedBy: LocationKeys.self)
        let locationValues = try locationBlock.nestedContainer(keyedBy: CodingRoomKeys.self, forKey: .location)
        maxRoomSeats = try locationValues.decode(Int.self, forKey: .maxRoomSeats)
        location = try Activity.getLocation(values: locationValues) ?? "Unknown"
    }
}
