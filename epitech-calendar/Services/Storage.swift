//
//  Storage.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 07/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit
import CoreData

enum EntityName : String {
    case User = "User"
}

struct Storage {
    static let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    static let context: NSManagedObjectContext? = Storage.appDelegate?.persistentContainer.viewContext
    
    static func save() {
        guard let context = Storage.context else { return }
        do {
            try context.save()
        } catch {
            print("aie")
            return
        }
    }

    static func createEntity(entityName: EntityName) -> NSEntityDescription? {
        guard let context = Storage.context else { return nil }
        return NSEntityDescription.entity(forEntityName: entityName.rawValue, in: context)
    }
    
    static func removeItems(entityName: EntityName) {
        guard let context = Storage.context else { return }
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        } catch let error {
            print(error)
        }
    }

    
    static func loadItems<T>(entityName: EntityName) -> [T]? {
        guard let context = Storage.context else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        do {
            guard let data = try (context.fetch(request)) as? [T] else { return nil }
            return data
        } catch let error {
            print(error)
            return nil
        }
    }
    
    static func loadItem<T>(entityName: EntityName) -> T? {
        guard let data: [T] = Storage.loadItems(entityName: entityName) else { return nil }
        guard data.count == 1 else { return nil }
        return data.first
    }
}
