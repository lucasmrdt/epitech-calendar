//
//  AuthenticationViewControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 07/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit
import WebKit

class AuthenticationControler : UIViewController, SegueHandler {
    
    var authToken: String?
    
    @IBAction func authTokenGotten(_ sender: UIStoryboardSegue) {
        EpitechAPI.Api.authToken = authToken!
        redirectToLoginScreen()
    }
    @IBAction func authLoginFailed(_ sender: UIStoryboardSegue) {
        EpitechAPI.Api.authToken = nil
        clearCookie()
    }
    
    override func viewDidLoad() {
        getUserAuthToken()
    }
    
    private func redirectToLoginScreen() {
        DispatchQueue.main.async {
            self.performSegueWithIdentifier(segueIdentifier: .AuthLogin, sender: nil)
        }
    }
    
    private func getUserAuthToken() {
        if EpitechAPI.Api.hasToken {
            redirectToLoginScreen()
        }
    }
    
    private func clearCookie() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    }
}
