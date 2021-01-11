//
//  WebViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-10.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView()
        
//        webView.uiDelegate = self
        
        view.addSubview(webView)
        view.constrainSubviewToBounds(webView)
        
//        webView.loadHTMLString("<html><body><p>Hello!</p></body></html>", baseURL: nil)

        
        let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='200%'"
        webView.evaluateJavaScript(js, completionHandler: nil)
        
        if let filepath = Bundle.main.path(forResource: "Acknowledgements", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                webView.loadHTMLString(contents, baseURL: nil)
                print(contents)
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
    }
    
//    func webview
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='200%'"//dual size
//        webView.evaluateJavaScript(js, completionHandler: nil)
//    }
}
