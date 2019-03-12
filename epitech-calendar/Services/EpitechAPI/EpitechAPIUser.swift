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
        
        guard   let firstname   = json["firstname"]     as! String?,
                let lastname    = json["lastname"]      as! String?,
                let login       = json["login"]         as! String?,
                let semester    = json["semester"]      as! Int16?,
                let rawCourse   = json["course_code"]   as! String?,
                let rawPicture  = json["picture"]       as! String?,
                let rawGPA      = json["gpa"]           as! [[String: String]]?
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
extension InternalEpitechAPI {
    func fetchUserInformation(completion: @escaping (_ user: User?) -> ()) {
        func fetchSuccess(data: ([String: Any])) {
            user = createUserFromJSON(json: data)
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
