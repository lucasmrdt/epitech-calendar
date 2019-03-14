//
//  MonthScroller.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 13/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

// MARK - Helpers Functions
extension DateScroller {
    static func getTimestamp(day: Double, month: Double, year: Double) -> Double {
        let computedYear = year - Timestamp.baseYear
        return computedYear * Timestamp.year + month * Timestamp.month + day * Timestamp.day
    }
    
    static func getDateFromDay(day: Double) -> Date {
        let timestamp = DateScroller.getTimestamp(day: day, month: 2.0, year: 2019.0)
        return Date(timeIntervalSince1970: timestamp)
    }
}

// MARK - CollectionViewDataSource
extension DateScroller {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(dates.count)
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! DateScrollerCellView
        let date = dates[indexPath.row]
        let dateFormatGetter = DateFormatter()
        dateFormatGetter.dateFormat = dateFormat
        cell.label.text = dateFormatGetter.string(from: date)
        return cell
    }
}
