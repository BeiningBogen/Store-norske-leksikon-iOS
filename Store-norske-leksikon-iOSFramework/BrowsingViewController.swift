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
import AMScrollingNavbar

public class BrowsingViewController : UIViewController {

    let vm = BrowsingViewModel()
    
    let webView: WKWebView

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        webView = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration.init())
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required public init?(coder aDecoder: NSCoder) {
        webView = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration.init())
        super.init(coder: aDecoder)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(webView.scrollView, delay: 50.0)
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
        
        vm.inputs.viewDidLoad()
    }

    func setupViews() {
        
        view.addSubview(webView)
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
        
        vm.outputs.title.observeValues { [weak self] currentTitle in
            self?.title = currentTitle
        }
        
        vm.outputs.loadRequest.observeValues { [weak self] request in
            self?.webView.load(request)
        }
        
    }

}

extension BrowsingViewController : WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        webView.removeHeaderAndFooter()
        
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        vm.inputs.didReceiveAuthChallenge(challenge: challenge, completionHandler: completionHandler)
        
    }

}
