
import UIKit

enum AnimationType {
    case bounce, spin, pop
}

protocol Animatable {
    func startAnimations()
    func stopAnimations()
}

extension Animatable where Self: CALayer {
    func stopAnimations() {
        removeAllAnimations()
    }
}

typealias AnimatableLayer = CALayer & Animatable

final class AnimatableLayerFactory {
    static func layer(withFrame frame: CGRect, animation: AnimationType) -> AnimatableLayer {
        switch animation {
        case .bounce:
            return BouncingLayer(frame)
        case .spin:
            return SpinningLayer(frame)
        case .pop:
            return PoppingLayer(frame)
        }
    }
}

enum AnimationDefault {
    static let duration: CFTimeInterval = 1.33
    static let repeatCount: Float = .infinity
}

final class BouncingLayer: CAShapeLayer {
    init(_ frame: CGRect) {
        super.init()
        self.frame = frame
        self.backgroundColor = UIColor.red.cgColor
        self.cornerRadius = frame.width / 2
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BouncingLayer: Animatable {
    func startAnimations() {
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        animation.values   = [0.0, 30.0, -30.0, 30.0, 0.0]
        animation.keyTimes = [0.0,  0.2,   0.4, 0.6,  0.8, 1.0]
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
        animation.duration = AnimationDefault.duration
        animation.repeatCount = AnimationDefault.repeatCount
        animation.isAdditive = true
        add(animation, forKey: "bouncing.layer.animation")
    }
}

final class SpinningLayer: CAShapeLayer {
    init(_ frame: CGRect) {
        super.init()
        self.frame = frame
        self.backgroundColor = UIColor.green.cgColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpinningLayer: Animatable {
    func startAnimations() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        animation.duration = AnimationDefault.duration
        animation.repeatCount = AnimationDefault.repeatCount
        add(animation, forKey: "spinning.layer.animation")
    }
}

final class PoppingLayer: CAShapeLayer {
    init(_ frame: CGRect) {
        super.init()
        self.frame = frame
        self.backgroundColor = UIColor.blue.cgColor
        self.cornerRadius = frame.width / 2
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PoppingLayer: Animatable {
    func startAnimations() {
        let animation = CAKeyframeAnimation()
        animation.keyPath  = "transform.scale"
        animation.values   = [0.0, 0.2, -0.2, 0.2, 0.0]
        animation.keyTimes = [0.0, 0.2,  0.4, 0.6, 0.8, 1.0]
        animation.duration = AnimationDefault.duration
        animation.repeatCount = AnimationDefault.repeatCount
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 1.43, 1.0, 1.0)
        animation.isAdditive = true
        add(animation, forKey: "popping.layer.animation")
    }
}

// usage:

class ViewController: UIViewController {
    
    var animatableShapeLayers: [AnimatableLayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animatableShapeLayers = makeAnimatableShapeLayers()
        animatableShapeLayers.forEach {
            view.layer.addSublayer($0)
            $0.startAnimations()
        }
    }
    
    func makeAnimatableShapeLayers() -> [AnimatableLayer] {
        /* Layout calculations */
        let size: CGSize  = CGSize(width: 60.0, height: 60.0)
        let midX: CGFloat = view.bounds.midX - size.width / 2
        
        let originLeft   = CGPoint(x: midX - 100, y: view.bounds.midY)
        let originCenter = CGPoint(x: midX,       y: view.bounds.midY)
        let originRight  = CGPoint(x: midX + 100, y: view.bounds.midY)
        
        let bouncyShapeFrame   = CGRect(origin: originLeft,   size: size)
        let spinningShapeFrame = CGRect(origin: originCenter, size: size)
        let poppingShapeFrame  = CGRect(origin: originRight,  size: size)
        
        /* Creating layers with Class Factory Method */
        let bouncyShapeLayer   = AnimatableLayerFactory.layer(withFrame: bouncyShapeFrame,   animation: .bounce)
        let spinningShapeLayer = AnimatableLayerFactory.layer(withFrame: spinningShapeFrame, animation: .spin)
        let poppingShapeLayer  = AnimatableLayerFactory.layer(withFrame: poppingShapeFrame,  animation: .pop)
        
        return [bouncyShapeLayer, spinningShapeLayer, poppingShapeLayer]
    }
}

