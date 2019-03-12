//
//  WebViewControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 01/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit
import WebKit

class WebControler : UIViewController, WKNavigationDelegate, SegueHandler {
    
    @IBOutlet weak var webView: WKWebView!

    var authToken : String?

    let finalHost = "intra.epitech.eu"
    let authUrl = URL(string: "https://login.microsoftonline.com/common/oauth2/authorize?response_type=code&client_id=e05d4149-1624-4627-a5ba-7472a39e43ab&redirect_uri=https%3A%2F%2Fintra.epitech.eu%2Fauth%2Foffice365&state=%2F")!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeWebView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .AuthenticationSuccess:
            let dest = segue.destination as! AuthenticationControler
            dest.authToken = authToken!
        default: break
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let host = navigationAction.request.url?.host else { return }
        if host.contains(finalHost) && authToken == nil {
            authenticationSuccess()
        }
        decisionHandler(.allow)
    }

    private func authenticationSuccess() {
        webView.getCookies(for: finalHost) { cookies in
            guard let authToken = cookies["user"] else { return }
            self.authToken = authToken
            self.performSegueWithIdentifier(segueIdentifier: .AuthenticationSuccess, sender: self)
        }
    }

    private func initializeWebView() {
        webView.navigationDelegate = self
        webView.load(URLRequest(url: authUrl))
        webView.allowsBackForwardNavigationGestures = true
    }

}
