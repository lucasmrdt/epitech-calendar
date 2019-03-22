//
//  ActivityScrollerLoadingView.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 22/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityScrollerLoadingView : UICollectionReusableView {
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView! {
        didSet {
            loadingIndicator.startAnimating()
        }
    }
}
