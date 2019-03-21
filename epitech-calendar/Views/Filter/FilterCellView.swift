//
//  FilterCellView.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 11/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class FilterCellView : UICollectionViewCell {

    @IBOutlet weak var cellLabel: UILabel!

    var isCellSelected: Bool = false {
        didSet {
            if isCellSelected {
                selectButton()
            } else {
                unselectButton()
            }
        }
    }
    var label: String = "" {
        didSet {
            cellLabel.text = label
        }
    }
    
    private func setupButton() {
        cellLabel.layer.borderColor = UIColor.white.cgColor
        cellLabel.layer.borderWidth = 1
        cellLabel.layer.cornerRadius = 5
        cellLabel.layer.masksToBounds = true
    }

    private func selectButton() {
        setupButton()
        cellLabel.backgroundColor = .white
        cellLabel.textColor = Colors.DarkBlueBg
    }
    
    private func unselectButton() {
        setupButton()
        cellLabel.backgroundColor = Colors.DarkBlueBg
        cellLabel.textColor = .white
    }

}
