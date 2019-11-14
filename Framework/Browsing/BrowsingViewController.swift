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
import ReactiveSwift
import Result

struct AppState {
    
    var count = 0
    var url: URL? = URL.init(string: "snl.no")
    var showError = false
    var showMoreOptionsMenu = false
    
    struct Activity {
        let type: ActivityType
        let timestamp = Date()
        
        enum ActivityType {
            case didBrowseToArticle(URL)
            case didTapMoreOptionsButton
        }
    }
}

public enum BrowsingAction {
    case tappedLink(URLRequest)
    case moreButtonTapped
}

func browsingReducer(state: AppState, action: BrowsingAction) -> AppState {
    
    switch action {
        
    case .tappedLink(let urlRequest):
        return AppState.init(count: state.count, url: urlRequest.url, showError: state.showError, showMoreOptionsMenu: state.showMoreOptionsMenu)

    case .moreButtonTapped:
        return AppState.init(count: state.count + 900, url: state.url, showError: state.showError, showMoreOptionsMenu: true)
    }
}

final class Store<Value, Action> {
    
    let reducer : (Value, Action) -> Value
    
    var value: MutableProperty<Value>
    
    init(value: MutableProperty<Value>, reducer: @escaping (Value, Action) -> Value) {
        self.value = value
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        value.value = self.reducer(self.value.value, action)
    }
}

class ArticleViewController : UIViewController {
    
    var store : Store<AppState, BrowsingAction>
    
    init(store: Store<AppState, BrowsingAction>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.value.signal
            .map(\.count)
            .observeValues { value in
                print("count : \(value)")
        }
        
        store.value.signal
            .filterMap { $0.showError }
            .skipRepeats()
            .observeValues { value in
                print("show error")

        }
        
        setupUI()
    }
    
    func setupUI() {
        
        let stackView = UIStackView.init(frame: UIScreen.main.bounds)
        view.addSubview(stackView)
        let tapButton = UIButton(type: .contactAdd)
        tapButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        stackView.addArrangedSubview(tapButton)
    }
    
    @objc
    func didTapButton() {
        store.send(.moreButtonTapped)
//        let newValue = browsingState.value
//        newValue.url = nil
//        browsingState.value = newValue
    }
}

public class BrowsingViewController : UIViewController {

    public let vm = BrowsingViewModel()
    public var outputs: BrowsingViewModel.Outputs!
    
    var toolBar: SearchToolbar!
    
    let webView: WKWebView
    var loadWithRequest: URLRequest?
    let speech = AVSpeechSynthesizer.init()
    

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        webView = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration.init())
        outputs = vm.outputs()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
        webView = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration.init())
        outputs = vm.outputs()
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let initialValue = (AppState(), browsingReducer(state:action:))
    
        let store = Store<AppState, BrowsingAction>.init(value: MutableProperty<AppState>.init(AppState()), reducer:browsingReducer)

        let myViewController = ArticleViewController.init(store: store)

////            MutableProperty<BrowsingState>.init(BrowsingState.init(state: appState)
//            )
//        )
        present(myViewController, animated: true, completion: nil)

//        self.store.send(AppAction.increase)

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
        
        let shareButton = UIBarButtonItem.init(title: "Mer", style: .plain, target: self, action: #selector(didTapShareButton))
        navigationItem.rightBarButtonItem = shareButton
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

