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
    public var splashScreen: SplashScreenProtocol?
    
    var toolBar: SearchToolbar!
    
    let webView: WKWebView
    let speech = AVSpeechSynthesizer.init()
    

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
        webView.setCustomUserAgent()

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
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .white

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
            self?.tabBarItem = UITabBarItem.init(title: "Utforsk".localized(key: "tab_explore") , image: UIImage.init(named: "globe_earth"), tag: 0)
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
            let shareButton = UIBarButtonItem.init(title: "Mer".localized(key: "navbar_more"), style: .plain, target: self, action: #selector(s.didTapShareButton))
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
            ModalLoader.showOrHide(value: value, inView: self?.view, type: .singleImageSpinning)
            if value == false {
                self?.splashScreen?.animateFadeout()
            }
        }
        
        outputs.showMoreOptionsController.observeValuesForUI { [weak self] value in
            
            let actionSheet = UIAlertController.init(title: "Handlinger".localized(key: "actionsheet_title"), message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction.init(title: "Les opp hele artikkelen".localized(key: "actionsheet_read_article"), style: .default, handler: { (_) in
                self?.vm.inputs.didTapVoiceoverButtonObserver.send(value: ())
            }))
                
            actionSheet.addAction(UIAlertAction.init(title: "Del lenke til artikkelen".localized(key: "actionsheet_share_article"), style: .default, handler: { (_) in
                self?.vm.inputs.didTapShareURLButtonObserver.send(value: ())
            }))
            
            actionSheet.addAction(UIAlertAction.init(title: "Avbryt".localized(key: "actionsheet_abort"), style: .cancel, handler: nil))
            
            self?.present(actionSheet, animated: true, completion: nil)
        }
        
        outputs.showShareSheet.observeValuesForUI { [weak self] value in
            let controller = UIActivityViewController.init(activityItems: [URL.init(string: value)!], applicationActivities: [])
            self?.present(controller, animated: true, completion: nil)
        }
        
        outputs.startVoiceOver.observeValuesForUI  { [weak self] value in
            let utterance = AVSpeechUtterance.init(string: value)
            utterance.voice = AVSpeechSynthesisVoice(language: Current.appSettings.speechSynthesizedLanguage)
            self?.speech.speak(utterance)
        }
        
        outputs.stopVoiceOver.observeValuesForUI { [weak self] value in
            self?.speech.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        
        outputs.showExternalLinkAlert.observeValuesForUI { [weak self] shouldShow, url in
            
            guard let url = url else { return }
            
            let alert = UIAlertController(title: "Åpne lenke i nettleser?".localized(key: "external_link_alert_title"),
                                          message: "Dette vil ta deg ut av appen.".localized(key:"external_link_alert_message"), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Avbryt".localized(key:"cancel_external_link"), style: .cancel, handler: { _ in
                self?.dismiss(animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Åpne".localized(key:"open_external_link"), style: .default, handler: { _ in
                UIApplication.shared.open(url)
            }))
            
            if shouldShow {
                self?.present(alert, animated: true, completion: nil)
            }
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
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

