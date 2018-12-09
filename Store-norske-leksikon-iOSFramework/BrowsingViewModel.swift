//
//  BrowsingViewModel.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 03/12/2018,49.
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

protocol BrowsingViewModelInputs {
    
    func viewDidLoad()
    func didBrowse(urlRequest: URLRequest)
    func didReceiveAuthChallenge(challenge: URLAuthenticationChallenge, completionHandler: ((URLSession.AuthChallengeDisposition, URLCredential?) -> Void)?)
}

protocol BrowsingViewModelOutputs {
    
    var title: Signal<String, NoError> { get }
    var html: Signal<String, NoError> { get }
    var loadRequest: Signal<URLRequest, NoError> { get }
    
}

protocol BrowsingViewModelType {
    var inputs: BrowsingViewModelInputs { get }
    var outputs: BrowsingViewModelOutputs { get }
}

class BrowsingViewModel: BrowsingViewModelType, BrowsingViewModelInputs, BrowsingViewModelOutputs {

    init() {
        
        title = .empty
        html = .empty
        loadRequest = viewDidLoadProperty.signal.map {
            URLRequest.init(url: AppEnvironment.current.service.serverConfig.baseURL
                .appendingPathComponent("sau"))
        }
        
        didReceiveAuthChallengeProperty.signal.skipNil().observeValues { arg in
            
            let (challenge, completionHandler) = arg
            
            let basicAuth = AppEnvironment.current.service.serverConfig.basicHTTPAuth!
            let credential = URLCredential(user: basicAuth.username , password: basicAuth.password, persistence: URLCredential.Persistence.forSession)
            challenge.sender?.use(credential, for: challenge)
            completionHandler?(URLSession.AuthChallengeDisposition.useCredential, credential)
            
        }

    }
    
    let viewDidLoadProperty = MutableProperty(())
    func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }
    
    let didReceiveAuthChallengeProperty = MutableProperty<(URLAuthenticationChallenge, ((URLSession.AuthChallengeDisposition, URLCredential?) -> ())?)?>(nil)
    func didReceiveAuthChallenge(challenge: URLAuthenticationChallenge, completionHandler: ((URLSession.AuthChallengeDisposition, URLCredential?) -> Void)?) {

        didReceiveAuthChallengeProperty.value = (challenge, completionHandler)
    }

    func didBrowse(urlRequest: URLRequest) {
        
    }
    
    let loadRequest: Signal<URLRequest, NoError>
    let title: Signal<String, NoError>
    let html: Signal<String, NoError>

    var inputs: BrowsingViewModelInputs { return self }
    var outputs: BrowsingViewModelOutputs { return self }
}
