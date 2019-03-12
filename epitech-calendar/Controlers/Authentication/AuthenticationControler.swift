//
//  AuthenticationViewControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 07/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class AuthenticationControler : UIViewController, SegueHandler {
    
    var authToken: String?
    
    @IBAction func authenticationSuccess(_ sender: UIStoryboardSegue) {
        saveUserAuthToken()
    }
    
    override func viewDidLoad() {
        getUserAuthToken()
    }
    
    private func redirectUserToApp() {
        DispatchQueue.main.async {
            self.performSegueWithIdentifier(segueIdentifier: .RedirectAuthenticationSuccess, sender: nil)
        }
    }
    
    private func saveUserAuthToken() {
        guard let context = Storage.context else { return }
        let user = User(context: context)
        user.authToken = authToken
        Storage.save()
        redirectUserToApp()
    }
    
    private func getUserAuthToken() {
        if let _: User = Storage.loadItem(entityName: .User) {
            redirectUserToApp()
        }
    }
}
