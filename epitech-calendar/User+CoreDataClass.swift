//
//  User+CoreDataClass.swift
//  
//
//  Created by Lucas Marandat on 12/03/2019.
//
//

import Foundation
import CoreData

enum UserCourse : String {
    case Bachelor = "bachelor"
    case PGT = "PGT"
}

struct UserGPAItem : Decodable {
    let rawGPA: String
    let gpa: Float
    let cycle: UserCourse
    
    enum CodingKeys : String, CodingKey {
        case rawGPA = "gpa"
        case cycle
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rawGPA = try values.decode(String.self, forKey: .rawGPA)
        gpa = Float(rawGPA) ?? 0.0
        let rawCycle = try values.decode(String.self, forKey: .cycle)
        cycle = UserCourse(rawValue: rawCycle) ?? .Bachelor
    }
}

public class User: NSManagedObject, Decodable {
    // MARK - Enumerations / Structure
    enum CodingKeys : String, CodingKey {
        case course = "course_code"
        case rawGPA = "gpa"
        case authToken, firstname, lastname, semester, picture, login
    }
    
    // MARK - CoreData
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
    
    var rawGPA: [UserGPAItem]?
    
    // MARK - Static Functions
    private static func getCourse(values: KeyedDecodingContainer<CodingKeys>) throws -> String {
        let rawCourse = try values.decode(String.self, forKey: .course)
        let firstPiece = rawCourse.split(separator: "/").first
        guard firstPiece != nil else { return UserCourse.Bachelor.rawValue }
        let course = String(firstPiece!)
        return UserCourse(rawValue: course)?.rawValue ?? UserCourse.Bachelor.rawValue
    }
    
    private static func getGPA(values: KeyedDecodingContainer<CodingKeys>, course: UserCourse) throws -> Float {
        let courses = try values.decode([UserGPAItem].self, forKey: .rawGPA)
        guard let course = courses.first(where: { $0.cycle == course }) else { return 0.0 }
        return course.gpa
    }
    
    private static func getPicture(values: KeyedDecodingContainer<CodingKeys>) throws -> String {
        let picture = try values.decode(String.self, forKey: .picture)
        return "\(EpitechAPI.Api.domainName)\(picture)"
    }

    // MARK - Decodable
    public required convenience init(from decoder: Decoder) throws {
        guard   let context = Storage.context,
                let entity = Storage.createEntity(entityName: .User)
        else { fatalError("Can't init User coreData") }

        self.init(entity: entity, insertInto: context)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstname = try values.decode(String.self, forKey: .firstname)
        lastname = try values.decode(String.self, forKey: .lastname)
        semester = try values.decode(Int16.self, forKey: .semester)
        login = try values.decode(String.self, forKey: .login)
        authToken = EpitechAPI.Api.authToken

        course = try User.getCourse(values: values)
        gpa = try User.getGPA(values: values, course: UserCourse(rawValue: course!)!)
        picture = try User.getPicture(values: values)
    }

}
