//
//  User+CoreDataProperties.swift
//  
//
//  Created by Lucas Marandat on 12/03/2019.
//
//

import Foundation
import CoreData

enum UserCourse : String {
    case PGT = "PGT"
    case Bachelor = "bachelor"
}

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var authToken: String?
    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var picture: String?
    @NSManaged public var semester: Int16
    @NSManaged public var course: String?
    @NSManaged public var gpa: Float
    @NSManaged public var login: String?

}
