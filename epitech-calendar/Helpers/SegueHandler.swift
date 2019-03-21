//
//  Segue.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 07/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation
import UIKit

enum SegueIdentifier : String {
    // MARK - Auth
    case AuthTokenGotten
    case AuthLogin
    case AuthLoginSucceed
    case AuthLoginFailed
}

protocol SegueHandler {}

extension SegueHandler where Self: UIViewController {
    
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard   let identifier = segue.identifier,
                let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier ?? "unknown").")
        }
        return segueIdentifier
    }
    
}
