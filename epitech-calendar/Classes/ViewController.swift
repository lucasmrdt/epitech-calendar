//
//  ViewController.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 01/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func removeNavigationBarBorder() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
