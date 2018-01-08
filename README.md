# Implementing native iOS Design Patterns in Swift 4.

The aim is to showcase 'real-world' design patterns instead of abstaract bullshit.
Mainly focused on iOS native ones.


## Class Factory Method (Factory Method)
 
 > Class Factory Method is used when there are several classes that implement a common protocol or share a common base class.
 This pattern allows implementation subclasses to provide specializations without requiring the components that rely on them
 to know any details of those classes and how they relate to each other.

 A good example of Factory Method in Foundation is Data class, here's the initializers for creating an instance:
 ```swift
    init(bytes: UnsafeRawPointer?, length: Int)
    init(bytesNoCopy: UnsafeMutableRawPointer, length: Int)
    init(bytesNoCopy: UnsafeMutableRawPointer, length: Int, deallocator: ((UnsafeMutableRawPointer, Int) -> Void)? = nil)
    init(bytesNoCopy: UnsafeMutableRawPointer, length: Int, freeWhenDone: Bool)
    init(data: Data)
```

#### Resources to check:
 
[Class Factory Methods](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/ClassFactoryMethods/ClassFactoryMethods.html#//apple_ref/doc/uid/TP40010810-CH8-SW1) in Apple's Cocoa Encyclopedia. </br> 
    [Factory Method Pattern](https://en.wikipedia.org/wiki/Factory_method_pattern)  in Wikipedia. </br>



### Implementation

```swift

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
```

### Usage:
##### Adding layers on ViewController view's layer and animating

```swift
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

```

## Class Cluster
 > A class cluster an architecture that groups a number of private, concrete subclasses under a public, abstract superclass (pattern based on Abstract Factory).
Class cluster is actually a specific implementation of a factory but the initialiser is used instead of the Factory Method to decide what instance to return. Also Factories are used to create instances implementing a protocol while Class Cluster is only suitable for creation of subclasses of an Abstract Class.
 
However Class Clusters can only be implemented in Objective-C. Unlike Objective-C (where we can just replace 'self' in init method, and return proper subclass object based on the input type) when we call init method of a class we get only instance of that particular class in Swift...so we can't rely on the init method to construct a Class Cluster. A substitution whould be to use a Class Factory Method instead.
 
  Cocoa is filled with Class Clusters implementations: NSNumber, NSString, NSArray, NSDictionary, NSData.

#### Resources to check:
[Class Cluster](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html#//apple_ref/doc/uid/TP40010810-CH4) in Apple's Cocoa Encyclopedia. </br>
[Class Cluster](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/ClassCluster.html#//apple_ref/doc/uid/TP40008195-CH7-SW1) in Apple's Cocoa DevPedia. </br>
