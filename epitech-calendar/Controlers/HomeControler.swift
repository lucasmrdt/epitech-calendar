//
//  HomeViewControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 10/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class HomeControler : UIViewController {
    // MARK - Variables
    var monthScrollerDelegate: MonthScrollerDelegate!
    var activityScrollerDelegate: ActivityScrollerDelegate!
    var timelineScrollerDelegate: TimelineScrollerDelegate!
    
    private var beginScrollingOffset: CGPoint?
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var activityCollectionView: UICollectionView!
    @IBOutlet weak var timelineCollectionView: UICollectionView!

    @IBAction func filterCancel(_ sender: UIStoryboardSegue) {
        activityScrollerDelegate.refreshActivities()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthScrollerDelegate = MonthScrollerDelegate(monthCollectionView: monthCollectionView)
        self.activityScrollerDelegate = ActivityScrollerDelegate(monthScrollerDelegate: monthScrollerDelegate, timelineCollectionView: timelineCollectionView, activityCollectionView: activityCollectionView)
        self.timelineScrollerDelegate = TimelineScrollerDelegate(timelineCollectionView: timelineCollectionView, activityCollectionView: activityCollectionView)
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        monthScrollerDelegate.viewDidAppear(animated)
    }
}

// MARK - Private Function
extension HomeControler {
    private func setupNavigationBar() {
        removeNavigationBarBorder()
        let leftButton = NavigationBarLeftButton(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
}

// MARK - UICollectionView DataSource
extension HomeControler : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case monthCollectionView:
            return monthScrollerDelegate.numberOfSections(in: collectionView)
        case activityCollectionView:
            return activityScrollerDelegate.numberOfSections(in: collectionView)
        case timelineCollectionView:
            return timelineScrollerDelegate.numberOfSections(in: collectionView)
        default:
            fatalError("Unknown collectionView \(collectionView)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case monthCollectionView:
            return monthScrollerDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        case activityCollectionView:
            return activityScrollerDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        case timelineCollectionView:
            return timelineScrollerDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        default:
            fatalError("Unknown collectionView \(collectionView)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case monthCollectionView:
            return monthScrollerDelegate.collectionView(collectionView ,viewForSupplementaryElementOfKind: kind, at: indexPath)
//        case activityCollectionView:
//            return activityScrollerDelegate.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        default:
            fatalError("Unknown collectionView \(collectionView)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case monthCollectionView:
            return monthScrollerDelegate.collectionView(collectionView, cellForItemAt: indexPath)
        case activityCollectionView:
            return activityScrollerDelegate.collectionView(collectionView, cellForItemAt: indexPath)
        case timelineCollectionView:
            return timelineScrollerDelegate.collectionView(collectionView, cellForItemAt: indexPath)
        default:
            fatalError("Unknown collectionView \(collectionView)")
        }
    }
}

// MARK - UICollectionViewDelegate
extension HomeControler : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginScrollingOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.restorationIdentifier {
        case IdentifierConstants.activityRestorationID,
             IdentifierConstants.timelineRestorationID:
            guard activityCollectionView.isScrolling || timelineCollectionView.isScrolling else { return }
            activityScrollerDelegate.scrollViewDidScroll(scrollView)
            timelineScrollerDelegate.scrollViewDidScroll(scrollView)
        default: break
        }
    }
}

// MARK - UICollectionViewDelegateFlowLayout
extension HomeControler : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case timelineCollectionView:
            return timelineScrollerDelegate.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        case monthCollectionView:
            return monthScrollerDelegate.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        default:
            fatalError("Unknown collectionView \(collectionView)")
        }
    }
}
