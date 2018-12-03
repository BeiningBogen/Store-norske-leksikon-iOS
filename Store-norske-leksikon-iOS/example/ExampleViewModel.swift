import ReactiveCocoa
import ReactiveSwift
import Result

public protocol ExampleViewModelInputs {
    func viewDidLoad()
    func configure(text:String)
    func closeTapped()
}

public protocol ExampleViewModelOutputs {
    var title: Signal<String, NoError> { get }
    var goBack: Signal<Void, NoError> { get }
}

public protocol ExampleViewModelType {
    var inputs: ExampleViewModelInputs { get }
    var outputs: ExampleViewModelOutputs { get }
}

public class ExampleViewModel: ExampleViewModelType, ExampleViewModelInputs, ExampleViewModelOutputs {
    init() {
        title = configureWithTextProperty.signal.skipNil()
        goBack = closeTappedProperty.signal
    }
    
    let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }
    
    let configureWithTextProperty = MutableProperty<String?>(nil)
    public func configure(text: String) {
        configureWithTextProperty.value = text
    }
    
    let closeTappedProperty = MutableProperty(())
    public func closeTapped() {
        closeTappedProperty.value = ()
    }
    
    public let goBack: Signal<Void, NoError>
    public let title: Signal<String, NoError>
    
    public var inputs: ExampleViewModelInputs { return self }
    public var outputs: ExampleViewModelOutputs { return self }
}
