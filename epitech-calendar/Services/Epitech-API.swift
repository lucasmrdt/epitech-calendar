//
//  Epitech-API.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 12/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation
import UIKit

class API {
    // MARK - Constants
    let userURL = "https://intra.epitech.eu/user/?format=json"
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

// MARK - Requests
extension API {
    private func fetch(url rawUrl: String, onSucceed: @escaping (([String: Any]) -> ()), onFail: @escaping (_ error: Any) -> ()) {
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
                let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: Any]
                onSucceed(json)
            } catch let error {
                onFail(error)
            }
        }
        
        task.resume()
    }
}

// MARK - JSON Parser
extension API {
    private func getCourse(rawCourse: String) -> String {
        let pieces: [Substring] = rawCourse.split(separator: "/")
        return String(pieces.first ?? "")
    }
    
    private func getGPA(rawGPA: [[String: String]], course: String) -> Float {
        guard   let gpaObject = rawGPA.first(where: { $0["cycle"] == course }),
                let gpa = gpaObject["gpa"]
        else { return 0.0 }
        return Float(gpa) ?? 0.0
    }
    
    private func getPicture(rawPicture: String) -> String {
        return domainName + rawPicture
    }
    
    private func createUserFromJSON(json: [String: Any]) -> User? {
        guard let context = Storage.context else { return nil }

        let user = User(context: context)

        guard   let firstname = json["firstname"] as! String?,
                let lastname = json["lastname"] as! String?,
                let login = json["login"] as! String?,
                let semester = json["semester"] as! Int16?,
                let rawCourse = json["course_code"] as! String?,
                let rawPicture = json["picture"] as! String?,
                let rawGPA = json["gpa"] as! [[String: String]]?
        else { return nil }

        let course = getCourse(rawCourse: rawCourse)
        user.firstname = firstname
        user.lastname = lastname
        user.login = login
        user.semester = semester
        user.course = course
        user.picture = getPicture(rawPicture: rawPicture)
        user.gpa = getGPA(rawGPA: rawGPA, course: course)
        user.authToken = authToken
        return user
    }
}

// MARK - Public methods
extension API {
    func fetchUserInformation(completion: @escaping (_ user: User?) -> ()) {
        func fetchSuccess(data: ([String: Any])) {
            user = createUserFromJSON(json: data)
            print(user!)
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
            return
        }
        fetchUserInformation(completion: { completion($0 != nil) })
    }
}

struct EpitechAPI {
    static let Api = API()
}
