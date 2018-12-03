import ReactiveCocoa
import ReactiveSwift
import Result

public protocol ExampleTableViewModelInputs {
    func viewDidLoad()
    func configure(texts: [String])
}

public protocol ExampleTableViewModelOutputs {
    var cells: Signal<[String], NoError> { get }
}

public protocol ExampleTableViewModelType {
    var inputs: ExampleTableViewModelInputs { get }
    var outputs: ExampleTableViewModelOutputs { get }
}

public class ExampleTableViewModel: ExampleTableViewModelType, ExampleTableViewModelInputs, ExampleTableViewModelOutputs {
    init() {
        cells = configureWithTextProperty.signal.skipNil()
    }
    
    let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }
    
    let configureWithTextProperty = MutableProperty<[String]?>(nil)
    public func configure(texts: [String]) {
        configureWithTextProperty.value = texts
    }
    
    public let cells: Signal<[String], NoError>
    
    public var inputs: ExampleTableViewModelInputs { return self }
    public var outputs: ExampleTableViewModelOutputs { return self }
}
