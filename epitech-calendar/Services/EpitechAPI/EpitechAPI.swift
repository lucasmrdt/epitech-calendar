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
        user = loadedUser
        authToken = loadedUser.authToken
    }
}

// MARK - Requests Helpers
extension InternalEpitechAPI {
    func fetch<T>(url rawUrl: String, onSucceed: @escaping ((T) -> ()), onFail: @escaping (_ error: Any) -> ()) {
        guard let url = URL(string: rawUrl) else {
            onFail("Invalid url: \(rawUrl)")
            return
        }

        var request = URLRequest(url: url)
        request.setValue(cookie, forHTTPHeaderField: "Cookie")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                onFail(error as Any)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! T
                onSucceed(json)
            } catch let error {
                onFail(error)
            }
        }
        
        task.resume()
    }
}

struct EpitechAPI {
    static let Api = InternalEpitechAPI()
}
