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
    private let cellLabelFormat = "EEE"
    private let cellNumberFormat = "dd"
    private let headerDateFormat = "MMMM"
    private let cellWidth = 40
    private let cellHeight = 40
    private let cellPadding = 10
    private let maxMonthFetched = 12
    private let currentDate = Date()

    // MARK - Variables
    var monthCollectionView: UICollectionView!

    private var daysByMonths = [[Date]]()

    init(monthCollectionView: UICollectionView) {
        self.monthCollectionView = monthCollectionView

        let layout = monthCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        setupMonth()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK - Public Functions
extension MonthScrollerDelegate {
    func selectItem(byDate date: Date) {
        guard   let firstMonth = daysByMonths.first?.first,
                let lastMonth = daysByMonths.last?.last
        else { return }
        
        guard date >= firstMonth && date <= lastMonth else { return }

        guard let selectedMonthIndex = daysByMonths.firstIndex(where: { date.isSameMonth(date: $0[0]) }) else { return }
        let selectedMonth = daysByMonths[selectedMonthIndex]
        guard let selectedDayIndex = selectedMonth.firstIndex(where: { date.isSameDay(date: $0) }) else { return }

        let indexPath = IndexPath(row: selectedDayIndex, section: selectedMonthIndex)
        
        DispatchQueue.main.async {
            self.monthCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK - Private Functions
extension MonthScrollerDelegate {
    private func getWidthOfMonth(month: [Date]) -> CGFloat {
        return CGFloat(month.count * cellWidth + (month.count - 1) * cellPadding)
    }
    
    private func setupMonth() {
        let currentDate = Date()
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: currentDate)!
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate)!
        daysByMonths = Date.generateMonths(startDate: startDate, endDate: endDate)
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
        dateFormatGetter.dateFormat = cellLabelFormat
        let dateLabel = dateFormatGetter.string(from: date)
        dateFormatGetter.dateFormat = cellNumberFormat
        let dateNumber = dateFormatGetter.string(from: date)
        cell.dayLabel.text = dateLabel
        cell.dayNumber.text = dateNumber
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func viewDidAppear(_ animated: Bool) {
        selectItem(byDate: Date())
    }
}
