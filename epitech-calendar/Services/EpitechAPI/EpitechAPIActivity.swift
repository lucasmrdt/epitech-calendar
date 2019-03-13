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
    private func getActivitiesFromData(data: Data) -> [Activity]? {
        let decoder = JSONDecoder()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            let safeActivities = try decoder.decode([Safe<Activity>].self, from: data)
            return safeActivities.filter({ $0.value != nil }).map({ $0.value! })
        } catch let error {
            print("Fail to parse JSON: \(error)")
            return nil
        }
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
    func fetchActivities(start: Date, end: Date, completion: @escaping (_ activities: [Activity]?) -> ()) {
        func fetchSuccess(data: Data) {
            let activities = getActivitiesFromData(data: data)
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
