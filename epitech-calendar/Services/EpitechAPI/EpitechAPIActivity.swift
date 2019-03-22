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
    private func getActivityUrl(start: Date, end: Date) -> String {
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
    
    private func findFreeRowIndex(rowActivities: [[Activity]], activity: Activity) -> Int? {
        for (i, row) in rowActivities.enumerated() {
            if row.isEmpty || !Activity.intersects(activity1: row.last!, activity2: activity) {
                return i
            }
        }
        return nil
    }
    
    private func dispatchActivitiesIntoRows(activities: [Activity]) -> [Activity] {
        var dispatchedActivities = [Activity]()
        var rowActivities = [[Activity]]()

        for var activity in activities {
            if let rowIndex = findFreeRowIndex(rowActivities: rowActivities, activity: activity) {
                rowActivities[rowIndex].append(activity)
                activity.row = rowIndex
            } else {
                rowActivities.append([activity])
                activity.row = rowActivities.count - 1
            }
            dispatchedActivities.append(activity)
        }

        return dispatchedActivities
    }
    
    private func sortActivities(activities: [Activity]) -> [Activity] {
        guard !activities.isEmpty else { return [Activity]() }

        let selectedSemesters = FilterModel.semesterSection.getSelectedItems()
        let filteredActivities = activities.filter({ selectedSemesters.contains($0.semester) })
        let sortedActivities = filteredActivities.sorted(by: { $0.start < $1.start })
        let dispatchedActivities = dispatchActivitiesIntoRows(activities: sortedActivities)

        return dispatchedActivities
    }
}

// MARK - Public methods
extension InternalEpitechAPI {
    func fetchActivities(start: Date, end: Date, onSucceed: @escaping (_ activities: [Activity]) -> (), onFailed: @escaping (_ error: Any) -> ()) {
        func fetchSuccess(data: Data) {
            let activities = getActivitiesFromData(data: data)
            if let activities = activities {
                let sortedActivities = sortActivities(activities: activities)
                onSucceed(sortedActivities)
            } else {
                onFailed("")
            }
        }

        func fetchFail(error: Any) {
            print(error)
            onFailed(error)
        }

        let url = getActivityUrl(start: start, end: end)
        self.fetch(url: url, onSucceed: fetchSuccess, onFail: fetchFail)
    }
}
