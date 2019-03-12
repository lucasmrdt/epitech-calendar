//
//  NavigationBarLeftButton.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 11/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class NavigationBarLeftButton : UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        setImage(UIImage(named: "calendar")!, for: .normal)
        setTitle("Calendar", for: .normal)
        titleLabel?.font = UIFont(name: Fonts.sourceSansProLight, size: 27)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
        isUserInteractionEnabled = false
    }

}
