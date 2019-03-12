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
