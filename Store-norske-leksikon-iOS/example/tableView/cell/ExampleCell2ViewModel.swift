import ReactiveCocoa
import ReactiveSwift
import Result

public protocol ExampleCell2ViewModelInputs {
    func configureWith(example: String)
}

public protocol ExampleCell2ViewModelOutputs {
    var title: Signal<String, NoError> { get }
}

public protocol ExampleCell2ViewModelType {
    var inputs: ExampleCell2ViewModelInputs { get }
    var outputs: ExampleCell2ViewModelOutputs { get }
}

class ExampleCell2ViewModel: ExampleCell2ViewModelType, ExampleCell2ViewModelInputs, ExampleCell2ViewModelOutputs {
    
    init() {
        title = configureWithProperty.signal.skipNil()
    }
    
    private let configureWithProperty = MutableProperty<String?>(nil)
    func configureWith(example: String) {
        configureWithProperty.value = example
    }
    
    public let title: Signal<String, NoError>
    
    var inputs: ExampleCell2ViewModelInputs { return self }
    var outputs: ExampleCell2ViewModelOutputs { return self }
}
