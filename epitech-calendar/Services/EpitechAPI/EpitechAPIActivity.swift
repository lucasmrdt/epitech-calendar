//
//  EpitechActivity.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 12/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation

// MARK - JSON Parser
extension InternalEpitechAPI {
    private func parseActivityFromJSON(json: [String: Any]) -> EpitechActivity? {
        guard   let codeModule              = json["codemodule"]                as? String,
                let codeInstance            = json["codeinstance"]              as? String,
                let canRegister             = json["allow_register"]            as? Bool,
                let isModuleAvaible         = json["module_available"]          as? Bool,
                let isModuleRegistred       = json["module_registered"]         as? Bool,
                let activityLabel           = json["acti_title"]                as? String,
                let rawStart                = json["start"]                     as? String,
                let rawEnd                  = json["end"]                       as? String,
                let totalRegistredStudents  = json["total_students_registered"] as? Int,
                let rawRoom                 = json["room"]                      as? [String: Any],
                let maxRoomSeats            = rawRoom["seats"]                  as? Int,
                let room                    = rawRoom["code"]                   as? String
        else {
            print(json)
            return nil
        }

        let dateFormaterGet = DateFormatter()
        dateFormaterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard   let start   = dateFormaterGet.date(from: rawStart),
                let end     = dateFormaterGet.date(from: rawEnd)
        else {
            return nil
        }
        
        var eventRegistration: EpitechActivity.EventRegistration?
        if let eventRegistrationRaw = json["event_registered"] as? Bool {
            eventRegistration = EpitechActivity.EventRegistration(rawValue: eventRegistrationRaw.description)
        } else if let eventRegistrationRaw = json["event_registered"] as? String {
            eventRegistration = EpitechActivity.EventRegistration(rawValue: eventRegistrationRaw)
        } else {
            return nil
        }
        
        guard eventRegistration != nil else { return nil }
        
        return EpitechActivity(eventRegistration: eventRegistration!, canRegister: canRegister, isModuleAvaible: isModuleAvaible, isModuleRegistred: isModuleRegistred, codeModule: codeModule, codeInstance: codeInstance, activityLabel: activityLabel, start: start, end: end, totalRegistredStudents: totalRegistredStudents, maxRoomSeats: maxRoomSeats, room: room)
    }

    private func parseActivitiesFromJSON(json: [[String: Any]]) -> [EpitechActivity]? {
        var activities = [EpitechActivity]()
        
        json.forEach { unparsedActivity in
            guard let activity = parseActivityFromJSON(json: unparsedActivity) else { return }
            activities.append(activity)
        }

        return activities
    }
}

// MARK - Helpers methods
extension InternalEpitechAPI {
    func getActivityUrl(start: Date, end: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let params = [
            "start": dateFormatterGet.string(from: start),
            "end": dateFormatterGet.string(from: end),
            "format": "json"
        ]
        let queryParams = params.map({ "\($0)=\($1)" }).joined(separator: "&")

        return "\(activityUrl)?\(queryParams)"
    }
}

// MARK - Public methods
extension InternalEpitechAPI {
    func getActivities(start: Date, end: Date, completion: @escaping (_ activities: [EpitechActivity]?) -> ()) {
        func fetchSuccess(data: ([[String: Any]])) {
            let activities = parseActivitiesFromJSON(json: data)
            completion(activities)
        }

        func fetchFail(error: Any) {
            print(error)
            completion(nil)
        }

        let url = getActivityUrl(start: start, end: end)
        fetch(url: url, onSucceed: fetchSuccess, onFail: fetchFail)
    }
}
