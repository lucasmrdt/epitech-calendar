//
//  ActivityScrollerCellView.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 15/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class ActivityScrollerCellView : UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var view: UIView! {
        didSet {
            view.layer.cornerRadius = 7
        }
    }
}
