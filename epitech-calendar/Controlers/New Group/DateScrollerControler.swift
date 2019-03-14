//
//  DateScrollerControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 14/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class DateScrollerControler {
    // MARK - Constants
    private let reuseCellIdentifier = "DateCell"
    private let dateFormat = "dd/MM/yyyy"
    private let cellWidth = 100
    private let cellPadding = 10

    // MARK - Variables
    var collectionView: UICollectionView?
    private var dates = [Date]()
    private var year = 2018
    private var month = 0 {
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
    private var threshold: CGFloat = 5
    private var beginCollectionView: CGFloat {
        get {
            return self.threshold
        }
    }
    private var endCollectionView: CGFloat {
        get {
            return CGFloat(dates.count * cellWidth + (dates.count - 1) * cellPadding) - self.threshold
        }
    }
    
    // MARK - Required Functions
    private func refreshDates() {
        dates = Date.generateDays(forYear: year, forMonth: month)
    }
    
    init() {
        let date = Date()
        let calendar = Calendar.current

        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        refreshDates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK - CollectionView
extension DateScrollerControler : UICollectionViewProtocol {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let width = scrollView.frame.size.width
        let max = endCollectionView - width
        print(offsetX)
        
        if offsetX > max {
//            print("her", offsetX, max)
            month += 1
            refreshDates()
            collectionView?.reloadData()
            scrollView.contentOffset = CGPoint(x: beginCollectionView, y: 0)
        } else if offsetX <= 0 {
            month -= 1
            refreshDates()
            collectionView?.reloadData()
            scrollView.contentOffset = CGPoint(x: endCollectionView - width - 20, y: 0)
        }
    }
}
