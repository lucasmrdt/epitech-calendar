//
//  ActivityScrollerDelegate.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 15/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class ActivityScrollerDelegate {
    // MARK - Constants
    private let reuseCellIdentifier = "ActivityCell"

    // MARK - Variables
    var timelineCollectionView: UICollectionView!
    var activityCollectionView: UICollectionView!

    private var selectedWeek = Date()
    private var state: State = .Default
    private var activities: [Activity]?
    private var numberOfRows: Double = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(timelineCollectionView: UICollectionView, activityCollectionView: UICollectionView) {
        self.timelineCollectionView = timelineCollectionView
        self.activityCollectionView = activityCollectionView
        let layout = activityCollectionView.collectionViewLayout as! ActivityScrollerLayout
        layout.delegate = self
        fetchActivities()
    }
}

// MARK - Private Functions
extension ActivityScrollerDelegate {
    private func reload() {
        DispatchQueue.main.async {
            self.activityCollectionView.reloadData()
        }
    }
    
    private func selectNewWeek(fromDate date: Date) {
        selectedWeek = date
    }
    
    private func onSucceedLoadActivities(activities: [Activity]) {
        self.activities = activities
        numberOfRows = Double(activities.reduce(0, { max($0, $1.row ?? 0) }))
        state = .Succeed
        reload()
    }
    
    private func onFailedLoadActivities(_ error: Any) {
        print("Failed to fetch Activities: \(error)")
        state = .Failed
        activityCollectionView.reloadData()
    }
    
    private func fetchActivities() {
        state = .Loading

        guard   let start = selectedWeek.startOfWeek,
                let end = selectedWeek.endOfWeek
        else {
            onFailedLoadActivities("")
            return
        }
        
        print(start, end)

        EpitechAPI.Api.fetchActivities(start: start, end: end, onSucceed: onSucceedLoadActivities, onFailed: onFailedLoadActivities)
    }
}

// MARK - ScrollerDelegateProtocol
extension ActivityScrollerDelegate : ScrollerDelegateProtocol {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .Succeed:
            return activities!.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! ActivityScrollerCellView

        switch state {
        case .Succeed:
            cell.label.text = activities![indexPath.row].activityLabel
        default: break
        }

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        timelineCollectionView?.contentOffset.x = scrollView.contentOffset.x
    }
}

// MARK - ActivityConstantsDelegate
extension ActivityScrollerDelegate : ActivityScrollerLayoutProtocol {
    private func getVerticalMargin() -> Double {
        let freeSpace: Double = ActivityConstants.contentHeight - numberOfRows * ActivityConstants.activityHeight
        return freeSpace / Double(numberOfRows + 1)
    }
    
    private func getItemWidth(activity: Activity) -> Double? {
        let component = Calendar.current.dateComponents([.hour, .minute], from: activity.start, to: activity.end)

        guard   let hourDifference = component.hour,
                let minuteDifference = component.minute
        else { return nil }

        let timeDifference = Double(hourDifference) + Double(minuteDifference) / Time.numberOfMinInHour
        return timeDifference * Double(ActivityConstants.hourWidth) - ActivityConstants.horizontalMargin
    }
    
    private func getItemX(activity: Activity) -> Double? {
        guard let startOfWeek = activity.start.startOfWeek else { return nil }
        let component = Calendar.current.dateComponents([.day], from: startOfWeek, to: activity.start)
        guard let dayDifference = component.day else { return nil }
        let globalX = Double(dayDifference) * ActivityConstants.hourWidth * ActivityConstants.numberHoursByDays
        let startActivityHour = Calendar.current.component(.hour, from: activity.start)
        let startActivityMinute = Calendar.current.component(.minute, from: activity.start)
        let startActivityTime = Double(startActivityHour) + Double(startActivityMinute) / Time.numberOfMinInHour
        let localX = (startActivityTime - ActivityConstants.beginHourOfDay) * ActivityConstants.hourWidth
        return globalX + localX + ActivityConstants.horizontalMargin + ActivityConstants.unitWidth/2
    }
    
    private func getItemY(activity: Activity) -> Double? {
        let verticalMargin = getVerticalMargin()
        guard let row = activity.row else { return nil }
        return (Double(row) + 1) * verticalMargin + Double(row) * ActivityConstants.activityHeight
    }

    func collectionView(_ collectionView: UICollectionView, rectForItemAtIndexPath: IndexPath) -> CGRect? {
        guard   state == .Succeed,
                let activities = activities
        else { return nil }
        
        let activity = activities[rectForItemAtIndexPath.row]
        guard let itemWidth = getItemWidth(activity: activity) else { return nil }
        guard let x = getItemX(activity: activity) else { return nil }
        guard let y = getItemY(activity: activity) else { return nil }

        return CGRect(x: x, y: y, width: itemWidth, height: ActivityConstants.activityHeight)
    }
}
