//
//  EpitechUser.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 12/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation

// MARK - JSON Parser
extension InternalEpitechAPI {
    private func getUserFromData(data: Data) -> User? {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch let error {
            print("Fail to parse JSON: \(error)")
            return nil
        }
    }
}

// MARK - Public methods
extension InternalEpitechAPI {
    func fetchUserInformation(completion: @escaping (_ user: User?) -> ()) {
        func fetchSuccess(data: Data) {
            let user = getUserFromData(data: data)
            self.user = user
            completion(user)
        }
        
        func fetchFail(error: Any) {
            print(error)
            completion(nil)
        }
        
        fetch(url: userURL, onSucceed: fetchSuccess, onFail: fetchFail)
    }
    
    func connectUser(completion: @escaping (_ isConnected: Bool) -> Void) {
        if !hasToken {
            completion(false)
        } else {
            fetchUserInformation(completion: { completion($0 != nil) })
        }
    }
}
