import ReactiveCocoa
import ReactiveSwift
import Result

public protocol SearchTableViewCellViewModelInputs {
    func configureWith(example: String)
}

public protocol SearchTableViewCellViewModelOutputs {
    var title: Signal<String, NoError> { get }
}

public protocol SearchTableViewCellViewModelType {
    var inputs: SearchTableViewCellViewModelInputs { get }
    var outputs: SearchTableViewCellViewModelOutputs { get }
}

class SearchTableViewCellCellViewModel: SearchTableViewCellViewModelType, SearchTableViewCellViewModelInputs, SearchTableViewCellViewModelOutputs {

    init() {
        title = configureWithProperty.signal.skipNil()
    }

    private let configureWithProperty = MutableProperty<String?>(nil)
    func configureWith(example: String) {
        configureWithProperty.value = example
    }

    public let title: Signal<String, NoError>

    var inputs: SearchTableViewCellViewModelInputs { return self }
    var outputs: SearchTableViewCellViewModelOutputs { return self }
}
