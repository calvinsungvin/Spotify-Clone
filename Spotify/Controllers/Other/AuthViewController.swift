//
//  AuthViewController.swift
//  Spotify
//
//  Created by Calvin Sung on 2021/9/9.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let prefs = config.defaultWebpagePreferences
        prefs?.allowsContentJavaScript = true
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        //exchange the code for access token
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        
        print("Code: \(code)")
        
        webView.isHidden = true
        
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] (success) in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
//                let mainAppTabBarVC = TabBarViewController()
//                mainAppTabBarVC.modalPresentationStyle = .fullScreen
//                self?.present(mainAppTabBarVC, animated: true, completion: nil)
                self?.completionHandler?(success)
            }
        }
    }
  

}
