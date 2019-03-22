//
//  DateScrollerCellView.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 13/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class MonthScrollerCellView : UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayNumber: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.layer.cornerRadius = 4
            if isSelected {
                self.backgroundColor = .white
                dayNumber.textColor = Colors.DarkBlueBg
                dayLabel.textColor = Colors.DarkBlueBg
            } else {
                self.backgroundColor = Colors.DarkBlueBg
                dayNumber.textColor = .white
                dayLabel.textColor = .white
            }
        }
    }
}
