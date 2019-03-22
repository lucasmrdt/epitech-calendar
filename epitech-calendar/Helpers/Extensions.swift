//
//  WKWebView.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 06/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import WebKit

extension WKWebView {
        
    private var httpCookieStore: WKHTTPCookieStore  {
        return WKWebsiteDataStore.default().httpCookieStore
    }

    func getCookies(for domain: String? = nil, completion: @escaping ([String : String]) -> Void) {
        var cookieDict = [String : String]()
        httpCookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.value
                    }
                }
            }
            completion(cookieDict)
        }
    }
}

extension UICollectionView {
    var isScrolling: Bool {
        get {
            return self.isDragging || self.isDecelerating
        }
    }
}

extension UIViewController {
    var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func removeNavigationBarBorder() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension Date {
    // @from https://stackoverflow.com/a/44847450
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func isSameDay(date: Date) -> Bool {
        return date.day == self.day && isSameMonth(date: date)
    }
    
    func isSameMonth(date: Date) -> Bool {
        return date.month == self.month && date.year == self.year
    }

    static func getDate(day: Int, month: Int, year: Int) -> Date {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return date
    }
    
    static func generateDays(fromMonth date: Date) -> [Date] {
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        let dateRange = range.map { self.getDate(day: $0, month: date.month, year: date.year) }
        return dateRange
    }
    
    static func generateMonths(startDate from: Date, endDate to: Date) -> [[Date]] {
        let difference = Date.monthsBetweenDates(startDate: from, endDate: to)
        var generatedDays = [[Date]]()

        for i in 0..<difference {
            let date = Calendar.current.date(byAdding: .month, value: i, to: from)!
            let daysOfMonth = Date.generateDays(fromMonth: date)
            generatedDays.append(daysOfMonth)
        }

        return generatedDays
    }
    
    static func monthsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: startDate, to: endDate)
        return components.month!
    }
}
