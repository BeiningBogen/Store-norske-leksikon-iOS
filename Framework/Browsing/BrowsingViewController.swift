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
import AVFoundation
fileprivate class BundleClass {}

public class BrowsingViewController : UIViewController {

    public let vm = BrowsingViewModel()
    public var outputs: BrowsingViewModel.Outputs!
    public var splashScreen: SplashScreen?
    
    var toolBar: SearchToolbar!
    
    let webView: WKWebView
    var loadWithRequest: URLRequest?
    let speech = AVSpeechSynthesizer.init()
    

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        webView = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration.init())
        outputs = vm.outputs()
        Bundle.ini
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
    
    public override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vm.inputs.viewWillDisappearObserver.send(value: ())
        
        
        
        
    }
    
    @objc
    func didTapShareButton() {
        vm.inputs.didTapMoreActionsButtonObserver.send(value: ())
    }
    
    func setupViews() {
        
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.isDirectionalLockEnabled = true

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
            self?.tabBarItem = UITabBarItem.init(title: "Utforsk", image: UIImage.init(named: "globe_earth"), tag: 0)
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
        
        outputs.addMoreButton.observeValues { [ weak self ] in
            guard let s = self else { return }
            let shareButton = UIBarButtonItem.init(title: "Mer", style: .plain, target: self, action: #selector(s.didTapShareButton))
            s.navigationItem.rightBarButtonItem = shareButton
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
        
        outputs.showLoader.observeValuesForUI { [weak self] value in
            ModalLoader.showOrHide(value: value, inView: self?.view)
            if value == false {
                self?.splashScreen?.animateFadeout()
            }
        }
        
        outputs.showMoreOptionsController.observeValuesForUI { [weak self] value in
            
            let actionSheet = UIAlertController.init(title: "Handlinger", message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction.init(title: "Les opp hele artikkelen", style: .default, handler: { (_) in
                self?.vm.inputs.didTapVoiceoverButtonObserver.send(value: ())
            }))
                
            actionSheet.addAction(UIAlertAction.init(title: "Del lenke til artikkelen", style: .default, handler: { (_) in
                self?.vm.inputs.didTapShareURLButtonObserver.send(value: ())
            }))
            
            actionSheet.addAction(UIAlertAction.init(title: "Avbryt", style: .cancel, handler: nil))
            
            self?.present(actionSheet, animated: true, completion: nil)
        }
        
        outputs.showShareSheet.observeValuesForUI { [weak self] value in
            let controller = UIActivityViewController.init(activityItems: [URL.init(string: value)!], applicationActivities: [])
            self?.present(controller, animated: true, completion: nil)
        }
        
        outputs.startVoiceOver.observeValuesForUI  { [weak self] value in
            let utterance = AVSpeechUtterance.init(string: value)
            utterance.voice = AVSpeechSynthesisVoice(language: "nb-NO")
            self?.speech.speak(utterance)
        }
        
        outputs.stopVoiceOver.observeValuesForUI { [weak self] value in
            self?.speech.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        
    }

    @objc func showSearchField() {
        vm.inputs.didTapSearchButtonObserver.send(value: ())
    }
    
}

extension BrowsingViewController : WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
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

