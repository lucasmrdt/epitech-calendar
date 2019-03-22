//
//  Epitech-API.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 12/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation
import UIKit

class InternalEpitechAPI {
    // MARK - Constants
    let userURL = "https://intra.epitech.eu/user/?format=json"
    let activityUrl = "https://intra.epitech.eu/planning/load"
    let domainName = "https://intra.epitech.eu"

    // MARK - Variables
    var authToken: String?
    var user: User? {
        didSet {
            Storage.save()
        }
    }

    // MARK - Getters Variables
    var hasToken: Bool {
        get {
            return authToken != nil
        }
    }
    var cookie: String {
        get {
            return "user=\(authToken ?? "")"
        }
    }
    
    init() {
        guard let loadedUser: User = Storage.loadItem(entityName: .User) else { return }
        self.user = loadedUser
        self.authToken = loadedUser.authToken
    }
}

// MARK - Requests Helpers
extension InternalEpitechAPI {
    func fetch(url rawUrl: String, onSucceed: @escaping ((Data) -> ()), onFail: @escaping (_ error: Any) -> ()) {
        guard let url = URL(string: rawUrl) else {
            onFail("Invalid url: \(rawUrl)")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(self.cookie, forHTTPHeaderField: "Cookie")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil && error == nil {
                onSucceed(data!)
            } else {
                onFail(error as Any)
            }
        }
        
        task.resume()
    }
}

struct EpitechAPI {
    static let Api = InternalEpitechAPI()
}
