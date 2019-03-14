//
//  HomeViewControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 10/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class HomeControler : UIViewController {
    // MARK - Constants
    let dateScrollerControler = DateScrollerControler()

    // MARK - Variables
    @IBOutlet weak var dateCollectionView: UICollectionView?

    @IBAction func filterCancel(_ sender: UIStoryboardSegue) {
    }
    
    private func fetchActivities() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let start = dateFormatterGet.date(from: "2019-03-11")!
        let end = dateFormatterGet.date(from: "2019-03-17")!
        EpitechAPI.Api.fetchActivities(start: start, end: end, completion: { dump($0!.filter({ $0.eventRegistration == .Registred })) })
    }
    
    private func setupNavigationBar() {
        removeNavigationBarBorder()
        let leftButton = NavigationBarLeftButton(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        dateScrollerControler.collectionView = dateCollectionView
    }
}

// MARK - UICollectionView DataSource
extension HomeControler : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case dateCollectionView:
            return dateScrollerControler.numberOfSections(in: collectionView)
        default:
            fatalError("Unknown collectionView \(collectionView)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case dateCollectionView:
            return dateScrollerControler.collectionView(collectionView, numberOfItemsInSection: section)
        default:
            fatalError("Unknown collectionView \(collectionView)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case dateCollectionView:
            return dateScrollerControler.collectionView(collectionView, cellForItemAt: indexPath)
        default:
            fatalError("Unknown collectionView \(collectionView)")
        }
    }
}

// MARK - UICollectionViewDelegate
extension HomeControler : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dateCollectionView?.isScrolling ?? false {
            dateScrollerControler.scrollViewDidScroll(scrollView)
        } else {
            fatalError("Unknown scrollView \(scrollView)")
        }
    }
}
