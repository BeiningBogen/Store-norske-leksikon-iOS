import XCTest
import ReactiveCocoa
import ReactiveSwift
import Result

@testable import Store_norske_leksikon_iOSFramework
@testable import Store_norske_leksikon_iOSApi

class ExampleViewModelTests: XCTestCase {
    
    let exampleViewModel = ExampleViewModel()
    let title = TestObserver<String, NoError>()
    
    override func setUp() {
        super.setUp()
        exampleViewModel.outputs.title.observe(title.observer)
    }
    
    override func tearDown() {}
    
    func testTitle() {
        exampleViewModel.configure(text: "Example")
        title.assertLastValue("Example")
        XCTAssertEqual(title.values.count, 1)
    }
}
