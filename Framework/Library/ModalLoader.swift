
import Foundation
import UIKit


class ModalLoader: UIImageView {
    
    private static let viewTag = 3141592
    
    static public func show(inView view: UIView?) {
        
        guard let view = view else { return }
        let loader = ModalLoader.init()
        view.addSubview(loader)
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loader.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loader.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loader.tag = viewTag
        loader.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        loader.alpha = 0
        loader.image = UIImage.init(named: "AppIcon")
        loader.layer.cornerRadius = 37
        loader.layer.masksToBounds = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startSpin()
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            loader.transform = .identity
            loader.alpha = 1

        }) { comp in }
    }
    
    static func hide(inView view: UIView?) {
        guard let view = view else { return }
        let loader = view.viewWithTag(ModalLoader.viewTag) as? ModalLoader
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            loader?.transform = CGAffineTransform.init(scaleX: 2, y: 2)
            loader?.alpha = 0
            
        }) { comp in
            loader?.removeFromSuperview()
        }
    }
    
    private func startSpin() {
        let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.fromValue = NSNumber(floatLiteral: 0)
        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        fullRotation.duration = 0.8
        fullRotation.repeatCount = 100
        self.layer.add(fullRotation, forKey: "360")
    }

    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ModalLoader {
    static func showOrHide(value: Bool, inView: UIView?) {
        if value {
            ModalLoader.show(inView: inView)
        } else {
            ModalLoader.hide(inView: inView)
        }
    }
    
}
