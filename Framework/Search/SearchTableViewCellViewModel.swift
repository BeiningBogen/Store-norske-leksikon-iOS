import ReactiveCocoa
import ReactiveSwift
import Result


public protocol SearchTableViewCellViewModelInputs {
    func configureWith(article: Article)
}

public protocol SearchTableViewCellViewModelOutputs {
    
    var title: Signal<String, NoError> { get }
    var excerpt: Signal<String, NoError> { get }
    var imageURL: Signal<String?, NoError> { get }
    
}

public protocol SearchTableViewCellViewModelType {
    var inputs: SearchTableViewCellViewModelInputs { get }
    var outputs: SearchTableViewCellViewModelOutputs { get }
}

class SearchTableViewCellViewModel: SearchTableViewCellViewModelType, SearchTableViewCellViewModelInputs, SearchTableViewCellViewModelOutputs {


    init() {
        
        let value = configureWithProperty.signal.skipNil()
        title = value.map { $0.headword }
        excerpt = value.map { $0.firstTwoSentences }
        
        imageURL = value
            .map { $0.imageURL }

    }

    private let configureWithProperty = MutableProperty<Article?>(nil)
    func configureWith(article: Article) {
        configureWithProperty.value = article
    }
    
    
    public let title: Signal<String, NoError>
    public let excerpt: Signal<String, NoError>
    public let imageURL: Signal<String?, NoError>

    var inputs: SearchTableViewCellViewModelInputs { return self }
    var outputs: SearchTableViewCellViewModelOutputs { return self }
}
