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
}

class ActivityScrollerLayout : UICollectionViewLayout {
    // MARK - Public Variables
    var delegate: ActivityScrollerLayoutProtocol!

    // MARK - Private Variables
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: Int(ActivityConstants.contentWidth), height: Int(ActivityConstants.contentHeight))
        }
    }

    override func prepare() {
        for item in 0..<collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = delegate.collectionView(collectionView!, rectForItemAtIndexPath: indexPath)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = (frame != nil ? frame! : CGRect(x: 20, y: 20, width: 20, height: 20))
            cache.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }

        return layoutAttributes
    }
}
