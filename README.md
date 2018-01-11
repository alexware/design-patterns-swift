# Implementing native (and not very native) iOS Design Patterns in Swift 4 ;]

The aim is to showcase 'real-world' design patterns instead of abstaract bullshit.
Mainly focused on iOS native ones.


## Factory Method (Virtual Constructor)
 > Factory Method is used when there are several classes that implement a common protocol or share a common base class.
 This pattern allows implementation subclasses to provide specializations without requiring the components that rely on them
 to know any details of those classes and how they relate to each other.

#### Resources to check:
 
[Class Factory Methods](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/ClassFactoryMethods/ClassFactoryMethods.html#//apple_ref/doc/uid/TP40010810-CH8-SW1) in Apple's Cocoa Encyclopedia. </br> 
    [Factory Method](https://en.wikipedia.org/wiki/Factory_method_pattern)  in Wikipedia. </br>

 A good example of Factory is Data class (Foundation), here's the initializers for creating an instance:
 ```swift
    init(bytes: UnsafeRawPointer?, length: Int)
    init(bytesNoCopy: UnsafeMutableRawPointer, length: Int)
    init(bytesNoCopy: UnsafeMutableRawPointer, length: Int, deallocator: ((UnsafeMutableRawPointer, Int) -> Void)? = nil)
    init(bytesNoCopy: UnsafeMutableRawPointer, length: Int, freeWhenDone: Bool)
    init(data: Data)
```

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
 
However Class Clusters can only be implemented in Objective-C. Unlike Objective-C (where we can just replace 'self' in init method, and return proper subclass object based on the input type) when we call init method of a class we get only instance of that particular class in Swift...so we can't rely on the init method to construct a Class Cluster. A substitution whould be to use a Factory instead.
 
  Cocoa is filled with Class Clusters implementations: NSNumber, NSString, NSArray, NSDictionary, NSData.

#### Resources to check:
[Class Cluster](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html#//apple_ref/doc/uid/TP40010810-CH4) in Apple's Cocoa Encyclopedia. </br>
[Class Cluster](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/ClassCluster.html#//apple_ref/doc/uid/TP40008195-CH7-SW1) in Apple's Cocoa DevPedia. </br>


## Builder
> Builder pattern separates the construction of a complex object from its representation so that the same construction process can create different representations. Builder pattern is not too much adopted in Objective-C/Swift.

> “I think all of the famous GoF patterns exist within Cocoa, but many are either trivially implemented or made less necessary thanks to Objective-C. For example, the Cocoa convention of two stage allocation and initialization makes the GoF Abstract factory and Builder patterns trivial.” - Eric Buck (author of Cocoa Design Patterns)

### Implementation
```swift
typealias TemplateRenderData = [String: AnyObject]

struct Metadata {
    // ...
    /* a bunch of data loaded from server (JSON config for example) */
}

protocol TemplateBuilder {
    init (with metadata: Metadata)
    func produceContentsData()
    func produceMarkupData()
    func produceThemeData()
    func build() -> TemplateRenderData
}

/* Initialized with metadata (config) and produces data for rendering */
class PresentationDataBuilder: TemplateBuilder {
    
    private var renderData = TemplateRenderData()
    private let metadata: Metadata
    
    // may own private services ...
    
    required init (with metadata: Metadata) {
        self.metadata = metadata
    }
    
    func produceContentsData() {
        // retrieve / process data (from some service (network/db) as an example)
        // modify renderData
    }
    
    func produceMarkupData() {
        // retrieve / process data
        // modify renderData
    }
    
    func produceThemeData() {
        // retrieve / process data
        // modify renderData
    }
    
    func build() -> TemplateRenderData {
        return renderData
    }
}
```

### Usage:
```swift
class PresentationViewController: UIViewController {
    
    // ...
    
    func produceTemplate() {
        let metadata = Metadata()
        let builder = PresentationDataBuilder(with: metadata)
        
        builder.produceContentsData()
        builder.produceMarkupData()
        builder.produceThemeData()
        
        let templateRenderData = builder.build()
        render(with: templateRenderData)
    }
    
    func render(with: TemplateRenderData) {
        // render presentation...
    }
}
```


## Singleton
> The intent of a Singleton is to ensure a class only has one instance, and provide a global point of access to it. 
Singletons in iOS SDK: FileManager, URLSession, Notification, UserDefaults, ProcessInfo (Foundation), UIApplication and UIAccelerometer (UIKit), SKPaymentQueue (StoreKit) etc.

### Implementation
```swift
class AccountManager {
  static let shared = AccountManager()
  
  var accountInfo = (userName: "Oleg", userId: "000000001")
  
  /* This prevents using AccountManager's initializer */
  private init() { }
}
```
### Usage:
```swift
let userName = AccountManager.shared.accountInfo.userName
let userId = AccountManager.shared.accountInfo.userId
```

## Object Pool
> Object Pools are used when we need some heavy object to be cached (because of expensive initialization).

Note: The Pool should be responsible for reseting the state of the objects. </br>
Definition, implementations and pitfals: </br>
[Object Pool](https://en.wikipedia.org/wiki/Object_pool_pattern) on Wikipedia. </br>

### Implementation

```swift
import Foundation

protocol StateResetable {
    func resetState()
}

protocol ObjectPool {
    associatedtype Object: StateResetable
    
    func getObject() -> Object?
    func returnObject(_: Object)
}

class Pool<T: StateResetable> {
    
    typealias Object = T
    
    private var _data = [T]()
    private let _queue = DispatchQueue(label: "com.zayatsoleh.objectpool.queue")
    private let _semaphore: DispatchSemaphore

    init(with objects: [T]) {
        _data.reserveCapacity(_data.count)
        for o in objects { _data.append(o) }
        _semaphore = DispatchSemaphore(value: objects.count)
    }
    
    func getObject() -> T? {
        var result: T?
        if (_data.count > 0) {
            
            let timeoutResult: DispatchTimeoutResult = _semaphore.wait(timeout: .distantFuture)
            /* The _semaphore.wait() call decrements the semaphore counter each time an object is removed from
             * the data object array (_data = [T]()) and blocks when there are no more items left to give out.
             */
            if timeoutResult == .success {
                _queue.sync {
                    result = self._data.remove(at: 0)
                }
            }
        }
        return result
    }
    
    func returnObject(_ object: T) {
        _queue.sync {
            /* Reseting state of the returned object.
             */
            object.resetState()
            
            _data.append(object)
            /* Increment semaphore counter.
             * Pool can give out +1 object now.
             */
            _semaphore.signal()
        }
    }
}
```

