//
//  HomeViewControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 10/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class HomeControler : UIViewController {

    @IBOutlet weak var leftNavBarButton: UIButton!
    
    @IBAction func filterCancel(_ sender: UIStoryboardSegue) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        removeNavigationBarBorder()
        let leftButton = NavigationBarLeftButton(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }

}
