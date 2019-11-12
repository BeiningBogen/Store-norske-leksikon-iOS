
import Foundation
import UIKit


class ModalLoader: UIView {
    
    private static let viewTag = 3141592
    
    /// Show a modal s
    static public func show(inView view: UIView?) {
        
        guard let view = view else { return }
        let loader = ModalLoader.init()
        view.addSubview(loader)
    
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loader.widthAnchor.constraint(equalToConstant: 70).isActive = true
        loader.heightAnchor.constraint(equalToConstant: 70).isActive = true
        loader.tag = viewTag
        loader.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
        loader.alpha = 1
        
        let imageView = UIImageView.init(image: UIImage.init(named: "SNLspinner01"))
        imageView.centerYAnchor.constraint(equalTo: loader.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: loader.centerXAnchor).isActive = true
        loader.tag = viewTag
        imageView.animationImages = [UIImage.init(named: "SNLspinner01")!, UIImage.init(named: "SNLspinner02")!, UIImage.init(named: "SNLspinner03")!, UIImage.init(named: "SNLspinner04")!, UIImage.init(named: "SNLspinner05")!]
        imageView.animationDuration = 3
        imageView.contentMode = .scaleAspectFit
        imageView.startAnimating()
        imageView.layer.masksToBounds = true
        loader.translatesAutoresizingMaskIntoConstraints = false

        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            loader.transform = .identity
            loader.alpha = 1

        }) { comp in
            
            loader.startSpin()
        }
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
        
        UIView.animate(withDuration: 0.75, delay: 0.0, options: [UIViewAnimationOptions.autoreverse , UIViewAnimationOptions.repeat], animations: {
            
//            self.alpha = 0.2

            
        }) { (comp) in
            
        }
//        let fullRotation = CABasicAnimation(keyPath: "transform.alpha")
//        let fullRotation = CABasicAnimation(keyPath: "opacity")
//        fullRotation.fromValue = NSNumber(floatLiteral: 0)
//        fullRotation.toValue = NSNumber.init(floatLiteral: 1)
////        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
//        fullRotation.duration = 0.8
//        fullRotation.repeatCount = 100
//        self.layer.add(fullRotation, forKey: "360")
    }

    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// convenience
extension ModalLoader {
    static func showOrHide(value: Bool, inView: UIView?) {
        if value {
            ModalLoader.show(inView: inView)
        } else {
            ModalLoader.hide(inView: inView)
        }
    }
    
}
