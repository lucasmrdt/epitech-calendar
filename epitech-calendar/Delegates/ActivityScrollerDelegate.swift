//
//  ActivityScrollerDelegate.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 15/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityScrollerDelegate {
    // MARK - Constants
    private let reuseCellIdentifier = "ActivityCell"
    private let reuseSupplementaryIdentifier = "ActivitySupplementary"
    private let indicatorSize: CGFloat = 30
    private let indicatorPadding: CGFloat = 15
    private let daysThreshold: CGFloat = 3

    // MARK - Variables
    var monthScrollerDelegate: MonthScrollerDelegate!
    var timelineCollectionView: UICollectionView!
    var activityCollectionView: UICollectionView!

    private var activities = [Activity]()
    private var numberOfRows: Double = 0
    private var numberOfWeeks: Double = 0
    private var selectedDate = Date() {
        didSet {
            monthScrollerDelegate.selectItem(byDate: selectedDate)
        }
    }
    private var state: State = .Default {
        didSet {
            switch state {
            case .Loading:
                showLoadingIndicator()
            default:
                hideLoadingIndicator()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(monthScrollerDelegate: MonthScrollerDelegate, timelineCollectionView: UICollectionView, activityCollectionView: UICollectionView) {
        activityCollectionView.register(UINib(nibName: "Test", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseSupplementaryIdentifier)

        self.monthScrollerDelegate = monthScrollerDelegate
        self.timelineCollectionView = timelineCollectionView
        self.activityCollectionView = activityCollectionView

        let layout = activityCollectionView.collectionViewLayout as! ActivityScrollerLayout
        layout.delegate = self

        refreshActivities()
    }
}

// MARK - Private Functions
extension ActivityScrollerDelegate {
    private func reload() {
        DispatchQueue.main.async {
            self.activityCollectionView.reloadData()
        }
    }
    
    private func selectNextDay() {
        guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) else { return }
        selectedDate = nextDate
    }
    
    private func selectPreviousDay() {
        guard let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) else { return }
        selectedDate = previousDate
    }
    
    private func getCurrentScrollingDate(contentOffset: CGPoint) -> Date? {
        guard let firstActivity = activities.first else { return nil }
        let numberDaysScrolled = Int(Double(contentOffset.x) / ActivityConstants.dayWidth)
        let scrollingDate = Calendar.current.date(byAdding: .day, value: numberDaysScrolled, to: firstActivity.start)
        return scrollingDate
    }
    
    private func updateNumbersOfRows() {
        numberOfRows = activities.reduce(numberOfRows, { acc, activity in
            let rowIndex = Double(activity.row ?? 0)
            return max(acc, rowIndex + 1)
        })
    }
}

// MARK - Network Functions
extension ActivityScrollerDelegate {
    private func fetchActivities(from date: Date, onSucceed: @escaping (_ activities: [Activity]) -> (), onFailed: @escaping (_ error: Any) -> ()) {
        guard   let start = selectedDate.startOfWeek,
                let end = selectedDate.endOfWeek
        else {
            onFailed("Unresolved start/end date of week.")
            return
        }
        
        EpitechAPI.Api.fetchActivities(start: start, end: end, onSucceed: onSucceed, onFailed: onFailed)
    }

    func refreshActivities(position: AddActivitiesPosition = .Last, date: Date? = nil) {
        func onSucceed(activites fetchedActivities: [Activity]) {
            numberOfWeeks = 1
            activities = fetchedActivities
            state = .Succeed
            updateNumbersOfRows()
            reload()
        }
        
        func onFailed(_ error: Any) {
            print("Failed to refresh Activities: \(error)")
            state = .Failed
            reload()
        }
        
        guard state != .Loading else { return }
        state = .Loading
        reload()
        
        fetchActivities(from: selectedDate, onSucceed: onSucceed, onFailed: onFailed)
    }
    
    enum AddActivitiesPosition { case First, Last }
    func fetchMoreActivities(fromDate date: Date, addTo position: AddActivitiesPosition = .Last) {
        func onSucceed(activites fetchedActivities: [Activity]) {
            print(activities.count)
            if position == .First {
                activities.insert(contentsOf: fetchedActivities, at: 0)
            } else {
                activities.append(contentsOf: fetchedActivities)
            }
            print(activities.count)
            numberOfWeeks += 1
            state = .Succeed
            updateNumbersOfRows()
            reload()
        }
        
        func onFailed(_ error: Any) {
            print("Failed to fetch Activities: \(error)")
            state = .Failed
            reload()
        }
        
        guard state != .LoadingMore else { return }
        state = .LoadingMore
        
        fetchActivities(from: date, onSucceed: onSucceed, onFailed: onFailed)
    }
}

// MARK - UI Functions
// TODO: move this into .xib file
extension ActivityScrollerDelegate {
    private func createLoadingIndicator(parentSize: CGRect) -> UIView {
        let frame = CGRect(x: parentSize.width/2 - indicatorSize/2, y: parentSize.height/2 - indicatorSize/2 - indicatorPadding, width: indicatorSize, height: indicatorSize)
        let loadingIndicator = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballPulse, color: .white)
        loadingIndicator.startAnimating()
        return loadingIndicator
    }
    
    private func createLabel(parentSize: CGRect) -> UILabel {
        let size = CGSize(width: 100, height: 30)
        let rect = CGRect(x: parentSize.width/2 - size.width/2, y: parentSize.height/2 - size.height/2 + indicatorPadding, width: 100, height: 30)
        let label = UILabel(frame: rect)
        label.font = UIFont(name: Fonts.sourceSansProLight, size: 23)
        label.text = "loading"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityCollectionView.backgroundView = UIView()
            let size = self.activityCollectionView.backgroundView!.frame
            let loadingIndicator = self.createLoadingIndicator(parentSize: size)
            let label = self.createLabel(parentSize: size)
            self.activityCollectionView.backgroundView!.addSubview(loadingIndicator)
            self.activityCollectionView.backgroundView!.addSubview(label)
        }
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityCollectionView.backgroundView = nil
        }
    }
}

// MARK - ScrollerDelegateProtocol
extension ActivityScrollerDelegate : ScrollerDelegateProtocol {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .Succeed,
             .LoadingMore:
            return activities.count
        default:
            return 0
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseSupplementaryIdentifier, for: indexPath) as! ActivityScrollerLoadingView
//        return supplementaryView
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! ActivityScrollerCellView

        switch state {
        case .Succeed,
             .LoadingMore:
            cell.label.text = activities[indexPath.row].activityLabel
        default: break
        }

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard state == .Succeed else { return }
        guard let scrollingDate = getCurrentScrollingDate(contentOffset: scrollView.contentOffset) else { return }
        
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.frame.size.width
        let contentWidth = collectionViewContentSize.width

        timelineCollectionView.contentOffset.x = offsetX
        
        if !selectedDate.isSameDay(date: scrollingDate) {
            selectedDate = scrollingDate
        }

        if offsetX > contentWidth - width {
            guard let nextWeek = Calendar.current.date(byAdding: .day, value: 2, to: selectedDate) else { return }
            fetchMoreActivities(fromDate: nextWeek, addTo: .Last)
        }
    }
}

// MARK - ActivityConstantsDelegate
extension ActivityScrollerDelegate : ActivityScrollerLayoutProtocol {
    private func getItemWidth(activity: Activity) -> Double? {
        let component = Calendar.current.dateComponents([.hour, .minute], from: activity.start, to: activity.end)

        guard   let hourDifference = component.hour,
                let minuteDifference = component.minute
        else { return nil }

        let timeDifference = Double(hourDifference) + Double(minuteDifference) / Time.numberOfMinInHour
        return timeDifference * Double(ActivityConstants.hourWidth) - ActivityConstants.horizontalMargin
    }
    
    private func getItemX(activity: Activity) -> Double? {
        guard let firstActivity = activities.first else { return nil }
        guard let startOfWeek = firstActivity.start.startOfWeek else { return nil }

        let component = Calendar.current.dateComponents([.day], from: startOfWeek, to: activity.start)
        guard let dayDifference = component.day else { return nil }

        let globalX = Double(dayDifference) * ActivityConstants.hourWidth * ActivityConstants.numberHoursByDays
        let startActivityHour = Calendar.current.component(.hour, from: activity.start)
        let startActivityMinute = Calendar.current.component(.minute, from: activity.start)
        let startActivityTime = Double(startActivityHour) + Double(startActivityMinute) / Time.numberOfMinInHour
        let localX = (startActivityTime - ActivityConstants.beginHourOfDay) * ActivityConstants.hourWidth
        return globalX + localX + ActivityConstants.horizontalMargin + ActivityConstants.halfHourWidth/2
    }
    
    private func getItemY(activity: Activity) -> Double? {
        guard let row = activity.row else { return nil }
        return (Double(row) + 1) * ActivityConstants.verticalMargin + Double(row) * ActivityConstants.activityHeight
    }

    func collectionView(_ collectionView: UICollectionView, rectForItemAtIndexPath: IndexPath) -> CGRect? {
        guard   state == .Succeed else { return nil }
        
        let activity = activities[rectForItemAtIndexPath.row]
        guard let itemWidth = getItemWidth(activity: activity) else { return nil }
        guard let x = getItemX(activity: activity) else { return nil }
        guard let y = getItemY(activity: activity) else { return nil }

        return CGRect(x: x, y: y, width: itemWidth, height: ActivityConstants.activityHeight)
    }
    
    var collectionViewContentSize: CGSize {
        get {
            let height = self.numberOfRows * ActivityConstants.activityHeight + (self.numberOfRows + 1) * ActivityConstants.verticalMargin
            let width = numberOfWeeks * ActivityConstants.weekWidth + ActivityConstants.hourWidth
            return CGSize(width: width, height: height)
        }
    }
}
