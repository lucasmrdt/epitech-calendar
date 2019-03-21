//
//  LoaderControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 12/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderControler: UIViewController, SegueHandler {
    
    @IBOutlet weak var loader: NVActivityIndicatorView!
    
    var authToken: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        loader.startAnimating()
        EpitechAPI.Api.connectUser(completion: onConnectionDone)
    }
    
    private func authLoginSucceed() {
        print(EpitechAPI.Api.user!)
        DispatchQueue.main.async {
            self.performSegueWithIdentifier(segueIdentifier: .AuthLoginSucceed, sender: nil)
        }
    }
    
    private func authLoginFailed() {
        DispatchQueue.main.async {
            self.performSegueWithIdentifier(segueIdentifier: .AuthLoginFailed, sender: nil)
        }
    }
    
    func onConnectionDone(success: Bool) {
        if success {
            authLoginSucceed()
        } else {
            authLoginFailed()
        }
    }
    
}
