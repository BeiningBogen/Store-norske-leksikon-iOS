
import Foundation
import UIKit
import Cartography

class ModalLoader: UIView {
    
    private static let viewTag = 3141592
    
    /// Show a modal s
    static public func show(inView view: UIView?) {
        
        guard let view = view else { return }

        let loader = ModalLoader.init()
        view.addSubview(loader)
        loader.backgroundColor = .white
        loader.alpha = 1
        loader.layer.cornerRadius = 28

        let imageView = UIImageView.init(image: UIImage.init(named: "frame1"))
        loader.addSubview(imageView)
        loader.clipsToBounds = false
        
        constrain(view, loader, imageView) { view, loader, imageView in

            loader.center == view.center
            loader.height == 56
            loader.width == 56

            imageView.width == 60
            imageView.height == 60

            imageView.center == loader.center
        }
        
        loader.tag = viewTag
        imageView.animationImages = [UIImage.init(named: "Frame 1")!,
                                     UIImage.init(named: "Frame 2")!,
                                     UIImage.init(named: "Frame 3")!,
                                     UIImage.init(named: "Frame 4")!,
                                     UIImage.init(named: "Frame 5")!,
                                     UIImage.init(named: "Frame 6")!,
                                     UIImage.init(named: "Frame 7")!,
                                     UIImage.init(named: "Frame 8")!,
                                     UIImage.init(named: "Frame 9")!,
                                     UIImage.init(named: "Frame 10")!,
                                     UIImage.init(named: "Frame 11")!,
                                     UIImage.init(named: "Frame 12")!,
                                     UIImage.init(named: "Frame 13")!,
                                     UIImage.init(named: "Frame 14")!,
                                     UIImage.init(named: "Frame 15")!,
                                     UIImage.init(named: "Frame 16")!,
                                     UIImage.init(named: "Frame 17")!,
                                     UIImage.init(named: "Frame 18")!,
                                     UIImage.init(named: "Frame 19")!,
                                     UIImage.init(named: "Frame 20")!,
                                     UIImage.init(named: "Frame 21")!,
                                     UIImage.init(named: "Frame 22")!,
                                     UIImage.init(named: "Frame 23")!,
        ]
        imageView.animationDuration = 1
        imageView.contentMode = .scaleAspectFit
        imageView.startAnimating()
        imageView.layer.masksToBounds = true

        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            
            loader.transform = .identity
            loader.alpha = 1

        }) { comp in
            
            loader.startSpin()
        }
    }
    
    static func hide(inView view: UIView?) {
        guard let view = view else { return }
        
        let loader = view.viewWithTag(ModalLoader.viewTag) as? ModalLoader
        
        UIView.animate(withDuration: 0.4, delay: 0.3, options: UIViewAnimationOptions.curveLinear, animations: {
            
            loader?.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            loader?.alpha = 0
            
        }) { isComplete in
            
            loader?.removeFromSuperview()
        }
    }
    
    private func startSpin() {
        
        UIView.animate(withDuration: 0.75, delay: 0.0, options: [UIViewAnimationOptions.autoreverse , UIViewAnimationOptions.repeat], animations: {
            
        }) { (comp) in }
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
