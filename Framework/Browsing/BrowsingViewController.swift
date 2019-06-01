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

public class BrowsingViewController : UIViewController {

    public let vm = BrowsingViewModel()
    public var outputs: BrowsingViewModel.Outputs!
    
    var toolBar: SearchToolbar!
    
    let webView: WKWebView
    var loadWithRequest: URLRequest?

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        webView = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration.init())
        outputs = vm.outputs()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required public init?(coder aDecoder: NSCoder) {
        webView = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration.init())
        outputs = vm.outputs()
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
        vm.inputs.viewDidLoadObserver.send(value: ())
    }
    
    func setupViews() {
        
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.isDirectionalLockEnabled = true

        self.navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems([UIBarButtonItem.init(title: "Søk", style: UIBarButtonItemStyle.done, target: self, action: #selector(showSearchField))], animated: false)
            
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

        outputs.browseOnSamePage.observeValues { [weak self] request in
            self?.webView.load(request)
        }
        
        outputs.browseToNewPage.observeValues { [weak self] request in
            let viewController = BrowsingViewController.init(nibName: nil, bundle: nil)
            viewController.vm.inputs.configureObserver.send(value: request)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        
        outputs.title.observeValues { [weak self] title in
            self?.title = title
        }
        
        outputs.requestForTitle.observeValues { [weak self] in
            self?.webView.titleInDocument() { title in
                self?.vm.inputs.foundTitleObserver.send(value: title)
            }
        }
        
        outputs.stripHeaderFooter.observeValues { [ weak self ] in
            self?.webView.removeHeaderAndFooter()
        }
        
        outputs.addDOMLoadStripScript.observeValues { [ weak self ] in
            self?.webView.removeHeaderAndFooterOnDOMLoad()
        }
        
        outputs.showSearchController.observeValues { [ weak self ] in
            
            let vc = SearchViewController.init(nibName: nil, bundle: nil)
            let searchController = UISearchController.init(searchResultsController: vc)
            searchController.searchBar.delegate = vc
            self?.present(searchController, animated: true, completion: nil)

            vc.didSelectArticleHandler = { [weak self] article in
                self?.vm.inputs.didSearchForArticleObserver.send(value: article)
            }

        }
        
        outputs!.showLoader.observeValuesForUI { [weak self] value in
            
            ModalLoader.showOrHide(value: value, inView: self?.view)
        }

    }

    @objc func showSearchField() {
        vm.inputs.didTapSearchButtonObserver.send(value: ())
    }
    
}

extension BrowsingViewController : WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        // TODO: error here
        vm.inputs.didFailNavigationObserver.send(value: ())
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        vm.inputs.decidePolicyForNavigationActionObserver.send(value: (action: navigationAction, decisionHandler: decisionHandler))
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        vm.inputs.didStartNavigationObserver.send(value: ())
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        vm.inputs.didFinishNavigationObserver.send(value: ())
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        vm.inputs.didCommitNavigationObserver.send(value: ())
    }
    
}
