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

}
