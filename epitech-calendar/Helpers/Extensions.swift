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

extension UIViewController {
    var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func removeNavigationBarBorder() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension UICollectionView {
    var isScrolling: Bool {
        get {
            return self.isDragging || self.isDecelerating
        }
    }
}

extension Date {
    static func getDate(day: Int, month: Int, year: Int) -> Date {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return date
    }
    
    static func generateDays(forYear year: Int, forMonth month: Int) -> [Date] {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let dateRange = range.map { self.getDate(day: $0, month: month, year: year) }
        return dateRange
    }
}
