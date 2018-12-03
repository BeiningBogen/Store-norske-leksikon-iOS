import ReactiveCocoa
import ReactiveSwift
import Result

public protocol ExampleCellViewModelInputs {
    func configureWith(example: String)
}

public protocol ExampleCellViewModelOutputs {
    var title: Signal<String, NoError> { get }
}

public protocol ExampleCellViewModelType {
    var inputs: ExampleCellViewModelInputs { get }
    var outputs: ExampleCellViewModelOutputs { get }
}

class ExampleCellViewModel: ExampleCellViewModelType, ExampleCellViewModelInputs, ExampleCellViewModelOutputs {
    
    init() {
        title = configureWithProperty.signal.skipNil()
    }
    
    private let configureWithProperty = MutableProperty<String?>(nil)
    func configureWith(example: String) {
        configureWithProperty.value = example
    }
    
    public let title: Signal<String, NoError>
    
    var inputs: ExampleCellViewModelInputs { return self }
    var outputs: ExampleCellViewModelOutputs { return self }
}
