import UIKit
import Cartography

public class ExampleViewController : UIViewController {
    
    public let exampleViewModel = ExampleViewModel()
    
    private var button: UIButton!
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
        
        exampleViewModel.inputs.viewDidLoad()
        exampleViewModel.inputs.configure(text: "Example")
    }
    
    func setupViews() {
        button = UIButton.init(frame: .zero)
        button.setTitle("Go to tableview", for: .normal)
        button.addTarget(self, action: #selector(ExampleViewController.goToTableview), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func setupConstraints() {
        constrain(view, button) { (viewProxy, buttonProxy) in
            buttonProxy.height == 50
            buttonProxy.centerX == viewProxy.centerX
            buttonProxy.centerY == viewProxy.centerY
        }
    }
    
    func bindStyles() {
        view.backgroundColor = .red
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
    }
    
    func bindViewModel() {
        exampleViewModel.outputs.title.observeValues{ [weak self] viewTitle in
            self?.title = viewTitle
        }
        
        exampleViewModel.outputs.goBack.observeValues{ [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func goToTableview() {
        let viewController = ExampleTableViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
