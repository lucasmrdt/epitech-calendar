//
//  TimelineScrollerDelegate.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 15/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class TimelineScrollerDelegate {
    // MARK - Constants
    private let reuseCellIdentifier = "TimelineCell"
    private let itemHeight = 40
    
    // MARK - Variables
    private var timelines = [TimelineModel]()

    var timelineCollectionView: UICollectionView!
    var activityCollectionView: UICollectionView!
    
    init(timelineCollectionView: UICollectionView, activityCollectionView: UICollectionView) {
        self.timelineCollectionView = timelineCollectionView
        self.activityCollectionView = activityCollectionView
        self.setupTimelines()
    }
}

// MARK - Private Functions
extension TimelineScrollerDelegate {
    private func setupTimelines() {
        let numberOfHour = ActivityConstants.numberHoursByDays * ActivityConstants.numberDaysToDisplay
        let numberOfTimeline = Int(numberOfHour * 2)
        let initialDate = Calendar.current.date(bySettingHour: Int(ActivityConstants.beginHourOfDay), minute: 0, second: 0, of: Date())!

        for minutes in 0..<numberOfTimeline {
            let minutesToAdd = (minutes % Int(ActivityConstants.numberHoursByDays * 2)) * 30
            let newDate = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: initialDate)!
            let timeline = TimelineModel(date: newDate, isSelected: false)
            timelines.append(timeline)
        }
    }
}

// MARK - ScrollerDelegateProtocol
extension TimelineScrollerDelegate : ScrollerDelegateProtocol {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timelines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! TimelineScrollerCellView
        let timeline = timelines[indexPath.row]
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm"
        cell.label.text = dateFormatterGet.string(from: timeline.date)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.frame.size.width
        let contentWidth = scrollView.contentSize.width
        
        activityCollectionView.contentOffset.x = scrollView.contentOffset.x

        if offsetX > contentWidth - width {
            setupTimelines()
            timelineCollectionView.reloadData()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ActivityConstants.halfHourWidth, height: Double(itemHeight))
    }
}
