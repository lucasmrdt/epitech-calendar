//
//  FiltersModel.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 11/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import Foundation

enum InputType { case Radio, Select }

protocol FilterSection {
    var key: String { get }
    var inputType: InputType { get }
    var defaultIndexes: [Int] { get }
    var items: [String] { get }
    
    func isSelected(index: Int) -> Bool
    func toggle(index: Int)
}

extension FilterSection {
    func getSelectedItems() -> [Int] {
        return UserDefaults.standard.object(forKey: key) as? [Int] ?? defaultIndexes
    }

    func setSelectedItems(items: [Int]) {
        UserDefaults.standard.set(items, forKey: key)
    }

    func isSelected(index: Int) -> Bool {
        return getSelectedItems().firstIndex(of: index) != nil
    }

    func toggle(index: Int) {
        switch inputType {
        case .Radio:
            setSelectedItems(items: [index])
        case .Select:
            var items = getSelectedItems()
            let foundedIndex = items.firstIndex(of: index)
            if let foundedIndex = foundedIndex {
                items.remove(at: foundedIndex)
                setSelectedItems(items: items)
            } else {
                setSelectedItems(items: [index] + items)
            }
        }
    }
}

struct ActivitySection: FilterSection {
    enum ActivityType: String, CaseIterable {
        case Project = "Project"
        case Activity = "Activity"
        case Module = "Module"
    }

    let key: String = "Activity"
    let inputType: InputType = .Radio
    let items: [String] = ActivityType.allCases.map({ $0.rawValue })
    let defaultIndexes: [Int] = [0]
}

struct CourseSection: FilterSection {
    enum CourseType: String, CaseIterable {
        case Bachelor = "Bachelor"
        case PGT = "PGT"
    }
    
    let key: String = "Course"
    let inputType: InputType = .Radio
    let items: [String] = CourseType.allCases.map({ $0.rawValue })
    let defaultIndexes: [Int] = [0]
}

struct SemesterSection: FilterSection {
    enum SemesterType: String, CaseIterable {
        case Zero = "Sem 0"
        case One = "Sem 1"
        case Two = "Sem 2"
        case Three = "Sem 3"
        case Four = "Sem 4"
        case Five = "Sem 5"
        case Six = "Sem 6"
        case Seven = "Sem 7"
        case Height = "Sem 8"
        case Nine = "Sem 9"
        case Ten = "Sem 10"
    }
    
    let key: String = "Semesters"
    let inputType: InputType = .Select
    let items: [String] = SemesterType.allCases.map({ $0.rawValue })
    let defaultIndexes: [Int] = [0, 3, 4]
}

struct FilterModel {
    static var activitySection: FilterSection = ActivitySection()
    static var courseSection: FilterSection = CourseSection()
    static var semesterSection: FilterSection = SemesterSection()

    static var sections: [FilterSection] = [
        FilterModel.activitySection,
        FilterModel.courseSection,
        FilterModel.semesterSection,
    ]
}
