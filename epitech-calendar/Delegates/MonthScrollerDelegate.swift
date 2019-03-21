//
//  DateScrollerControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 14/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class MonthScrollerDelegate {
    // MARK - Constants
    private let reuseCellIdentifier = "MonthCell"
    private let reuseHeaderIdentifier = "MonthHeader"
    private let cellDateFormat = "dd/MM/yyyy"
    private let headerDateFormat = "MMMM"
    private let cellWidth = 100
    private let cellHeight = 50
    private let cellPadding = 10
    private let maxMonthFetched = 12
    private let currentDate = Date()

    // MARK - Variables
    var monthCollectionView: UICollectionView!

    private var scrollViewWidth: CGFloat = 0
    private var daysByMonths = [[Date]]()
    private var year: Int
    private var month: Int {
        didSet {
            if month >= 12 {
                month = 0
                year += 1
            } else if month < 0 {
                month = 11
                year -= 1
            }
        }
    }

    init(monthCollectionView: UICollectionView) {
        let date = Date()
        let calendar = Calendar.current

        self.monthCollectionView = monthCollectionView

        let layout = monthCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        let currentMonth = Date.generateDays(forYear: year, forMonth: month)
        let monthWidth = getWidthOfMonth(month: currentMonth)
        scrollViewWidth += monthWidth
        daysByMonths.append(currentMonth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK - Helpers
extension MonthScrollerDelegate {
    private func getWidthOfMonth(month: [Date]) -> CGFloat {
        return CGFloat(month.count * cellWidth + (month.count - 1) * cellPadding)
    }
    
    private func fetchNextMonth() -> Bool {
        guard let maxDate = daysByMonths.last?.last else { return false }
        guard Date.monthsBetweenDates(startDate: currentDate, endDate: maxDate) < maxMonthFetched else { return false }

        month += 1
        let newMonth = Date.generateDays(forYear: year, forMonth: month)
        let contentSize = getWidthOfMonth(month: newMonth)
        scrollViewWidth += contentSize
        daysByMonths.append(newMonth)
        monthCollectionView.reloadData()
        return true
    }
    
    private func fetchPreviousMonth() -> Bool {
        let minDate = daysByMonths[0][0]
        guard Date.monthsBetweenDates(startDate: minDate, endDate: currentDate) < maxMonthFetched else { return false }

        month -= 1
        let previousMonth = Date.generateDays(forYear: year, forMonth: month)
        let contentSize = getWidthOfMonth(month: previousMonth)
        scrollViewWidth += contentSize
        daysByMonths.insert(previousMonth, at: 0)
        monthCollectionView.reloadData()
        return true
    }
}

// MARK - UICollectionViewProtocol
extension MonthScrollerDelegate : ScrollerDelegateProtocol {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return daysByMonths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysByMonths[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! MonthScrollerCellView
        let date = daysByMonths[indexPath.section][indexPath.row]
        let dateFormatGetter = DateFormatter()
        dateFormatGetter.dateFormat = cellDateFormat
        cell.label.text = dateFormatGetter.string(from: date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! MonthScrollerHeaderView
            let date = daysByMonths[indexPath.section][indexPath.row]
            let dateFormatGetter = DateFormatter()
            dateFormatGetter.dateFormat = headerDateFormat
            let month = dateFormatGetter.string(from: date)
            header.label.text = month.prefix(3).uppercased()
            return header
        default:
            fatalError("Invalid element type")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.frame.size.width

        if offsetX > scrollViewWidth - width {
            guard fetchNextMonth() else { return }
        } else if offsetX <= 0 {
            guard fetchPreviousMonth() else { return }
            let firstMonthWidth = getWidthOfMonth(month: daysByMonths[0])
            scrollView.contentOffset.x = firstMonthWidth
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
