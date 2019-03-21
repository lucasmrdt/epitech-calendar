//
//  JsonParsing.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 12/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation

// @from http://kean.github.io/post/codable-tips-and-tricks
struct Safe<Base: Decodable> : Decodable {
    let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            value = try container.decode(Base.self)
        } catch {
            print("Invalid value: \(error)")
            value = nil
        }
    }
}
