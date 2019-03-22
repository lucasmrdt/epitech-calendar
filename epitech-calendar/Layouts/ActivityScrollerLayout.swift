//
//  ActivityLayout.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 19/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit
import Foundation

protocol ActivityScrollerLayoutProtocol {
    func collectionView(_ collectionView: UICollectionView, rectForItemAtIndexPath: IndexPath) -> CGRect?
    var collectionViewContentSize: CGSize { get }
}

class ActivityScrollerLayout : UICollectionViewFlowLayout {
    // MARK - Public Variables
    var delegate: ActivityScrollerLayoutProtocol!

    // MARK - Private Variables
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        get {
            return self.delegate.collectionViewContentSize
        }
    }

    override func prepare() {
        cache.removeAll()
        for item in 0..<collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = delegate.collectionView(collectionView!, rectForItemAtIndexPath: indexPath)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame ?? CGRect(x: 20, y: 20, width: 20, height: 20)
            cache.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

//        layoutAttributes.append(layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))!)
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }

        return layoutAttributes
    }
    
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
//        attributes.frame = CGRect(x: Double(collectionViewContentSize.width) - ActivityConstants.hourWidth, y: 0, width: ActivityConstants.hourWidth, height: ActivityConstants.activityHeight)
//        return attributes
//    }
}
