//
//  BrowsingViewController.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 03/12/2018,49.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import UIKit
import Cartography
import WebKit
import Store_norske_leksikon_iOSApi

public class BrowsingViewController : UIViewController {

    let viewModel = BrowsingViewModel()
    
    let webView: WKWebView

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        webView = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration.init())
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required public init?(coder aDecoder: NSCoder) {
        webView = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration.init())
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
        
    }

    func setupViews() {
        
        view.addSubview(webView)
        webView.load(URLRequest.init(url: URL.init(string: "https://snl.no")!))
        webView.navigationDelegate = self

    }

    func setupConstraints() {
        
        constrain(view, webView) { (vp, webViewProxy) in
            
            webViewProxy.left == vp.left
            webViewProxy.right == vp.right
            webViewProxy.top == vp.top
            webViewProxy.bottom == vp.bottom
        
        }
        
    }

    func bindStyles() {
        view.backgroundColor = .white
    }

    func bindViewModel() {
        viewModel.outputs.title.observeValues { [weak self] currentTitle in
            self?.title = currentTitle
        }
    }
}

extension BrowsingViewController : WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        print(navigation)
        
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print(navigationAction.request)
        
        decisionHandler(.allow)
        
    }
    
}
