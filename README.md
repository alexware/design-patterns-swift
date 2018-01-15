# Implementing Design Patterns in Swift 4 ;]

Note: some of the code is omitted for brevity check out playground/project to see full implementation.

## Command
> Pattern is used to incapsulate an operation (parameters required to execute the operation) so that it can be invoked later or by a different component. </br> 

#### Cocoa/CocoaTouch Adaptation: </br> 
NSInvocation (cannot be used in Swift because of the different ways that Swift and Objective-C invoke methods), NSUndoManager (Cocoa).

### Implementation </br> 
##### (see full implementation in Command demo project)
```swift
protocol CommandProtocol {
    func execute(on receiver: AnyObject)
}

class Command<T>: CommandProtocol {
    
    private var instructions: ((T) -> Void)?
    
    init() {
        instructions = nil
    }
    
    init(_ instructions: @escaping (T) -> Void) {
        self.instructions = instructions
    }
    
    func execute(on receiver: AnyObject) {
        guard receiver is T else {
            fatalError("\(#file), \(#function), \(#line): Receiver is of unsupported type!")
        }
        instructions?(receiver as! T)
    }
}

/* Command subclasses: */

class CollectionCellConfigurationCommand: Command<CollectionViewCell> {
    
    private let networkClient: NetworkImageLoaderProtocol
    private var task: URLSessionTaskProtocol?
    private let imageURL: URL
    
    init(title: String, networkClient: NetworkImageLoaderProtocol = ImageNetworkClient(), imageURL: URL) {
        
        self.networkClient = networkClient
        self.imageURL = imageURL
        
        super.init { cell in
            cell.titleLabel.text = title
        }
    }
    
    override func execute(on receiver: AnyObject) {
        super.execute(on: receiver)
        
        guard let cell = receiver as? CollectionViewCell else {
            return
        }

        task = networkClient.request(url: imageURL) { downloadedImage in
            cell.imageView.image = downloadedImage
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}

class CollectionCellSelectionCommand: Command<CollectionViewCell> {
    
    private let application: UIApplication
    private let pageURL: URL
    
    init(pageURL: URL, application: UIApplication) {
        self.application = application
        self.pageURL = pageURL
        
        super.init { cell in
            // ...
        }
    }
    
    override func execute(on receiver: AnyObject) {
        super.execute(on: receiver)
        
        if application.canOpenURL(pageURL) {
            application.open(pageURL, options: [:], completionHandler: nil)
        }
    }
}
```

### Usage:
```swift
struct CollectionCellViewModelFactory {
    
    func create(with photoData: PhotoData) -> CollectionCellViewModel {
        
        let contentSize = CGSize(width: 360, height: 280)
        var commands = [CollectionCellViewModel.CommandKey: CommandProtocol]()

        /* Configuration */
        commands[.configuration] = CollectionCellConfigurationCommand(title: photoData.title, imageURL: photoData.imageURL)
        
        /* Selection */
        commands[.selection]     = CollectionCellSelectionCommand(pageURL: photoData.pageURL, application: UIApplication.shared)
        
        /* For Deselection no specific subclass, using generic Command */
        commands[.deselection]   = Command<CollectionViewCell> { cell in
            // ...
        }
        
        let viewmodel = CollectionCellViewModel(reuseIdentifier: CollectionViewCell.identifier,
                                                contentSize: contentSize,
                                                commands: commands)
        return viewmodel
    }
}

/* UICollectionViewDatasource example: */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = cellViewModels[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier,
                                                            for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        viewModel
            .commands[CollectionCellViewModel.CommandKey.configuration]?
            .execute(on: cell)
        
        return cell
    }
```

## Iterator
> Used to traverse a container and access the container's elements.</br> 

#### Cocoa/CocoaTouch Adaptation: </br> 
IteratorProtocol </br> 

### Implementation
```swift
struct Instruction {
    let name: String
}

/* IteratorProtocol to the next element and returns it, or `nil` if no next element
 * exists.
 */

struct InstructionsIterator: IteratorProtocol {
    private let instructions: [Instruction]
    private var current = 0
    
    init(_ instructions: [Instruction]) {
        self.instructions = instructions
    }
    
    mutating func next() -> Instruction? {
        let next = instructions.count > current ? instructions[current] : nil
        current += 1
        return next
    }
}

struct InstructionsWrapper {
    let instructions: [Instruction]
}

extension InstructionsWrapper: Sequence {
    func makeIterator() -> InstructionsIterator {
        return InstructionsIterator(instructions)
    }
}
```
### Usage:
```swift
let instructionsWrapper = InstructionsWrapper(instructions: [
    Instruction(name: "Analizing"),
    Instruction(name: "Seeking Humans..."),
    Instruction(name: "Destroying!"),
    Instruction(name: "Laughing. Mua-ha-ha.")
])

func execute(instruction: Instruction) {
    print(instruction)
}

for instrution in instructionsWrapper {
    execute(instruction: instrution)
}
```

## Facade
> Provides higher level interface to reduce the complexity of a subsystem so that common tasks can be performed more easily and the complexity required to use the API is consolidated in one part of the application.</br> 

#### Cocoa/CocoaTouch Adaptation: </br> 
NSCopiyng, NSImage</br> 

### Implementation
##### (see full implementation in Command demo project)

```swift
/* Facade over 3 modules
 * 1. RemoteImageProvider: downloads images from web.
 * 2. ImageDataProvider: generates image data representation (png/jpeg).
 * 3. DiskManager: helps to save/retrieve/remove downloaded images from disk.
 */

protocol ImageAPIProtocol {
    func saveRemoteImage(url: URL, name: String, format: ImageFormat, shouldOverwrite: Bool, callback: @escaping (Result<URL>) -> Void)
    func getSavedImageURLs() -> [URL]
    func retrieveSavedImage(with url: URL) -> UIImage?
    func removeSavedImages()
}

final class ImageAPIFacade: ImageAPIProtocol {
    
    private let loader = RemoteImageProvider()
    private let dataRepresentationProvider = ImageDataProvider()
    private let diskManager = DiskManager()
    
    func saveRemoteImage(url: URL, name: String, format: ImageFormat, shouldOverwrite: Bool = true, callback: @escaping (Result<URL>) -> Void)  {
        let savePath: URL = diskManager.saveDirectory.appendingPathComponent("\(name)")

        _ = loader.load(from: url, callback: { result in
            do {
                let image = try result.unwrap()
                let data = try self.dataRepresentationProvider.data(from: image, withFormat: format).unwrap()
                let writingOptions: Data.WritingOptions = shouldOverwrite ? .atomic : .withoutOverwriting
                try data.write(to: savePath, options: writingOptions)
                
                callback(.success(savePath))
                
            } catch let err {
                callback(.fail(err))
            }
        })
    }
    
    func getSavedImageURLs() -> [URL] {
        return diskManager.getSavedImageURLs()
    }
    
    func retrieveSavedImage(with url: URL) -> UIImage? {
        var image: UIImage?
        if let data = try? Data(contentsOf: url), let imageFromData = UIImage(data: data) {
            image = imageFromData
        }
        return image
    }
    
    func removeSavedImages() {
        diskManager.removeSavedImages()
    }
}
```

```swift
/* Facade submodules implementations: */

/* 1 */
protocol RemoteImageLoaderProtocol {
    func load(from url: URL, callback: @escaping (Result<UIImage>) -> Void) -> URLSessionTask
}

struct RemoteImageProvider: RemoteImageLoaderProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func load(from url: URL, callback: @escaping (Result<UIImage>) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    let error = ImageAPIError.failedLoadingFromNetwork(error)
                    callback(.fail(error))
                }
                return
            }
            DispatchQueue.main.async {
                callback(.success(image))
            }
        }
        task.resume()
        return task
    }
}

/* 2 */
enum ImageFormat {
    case png
    /* quality: CGFloat
     * value 0.0 represents the maximum compression (or lowest quality)
     * value 1.0 represents the least compression (or best quality).
     */
    case jpeg(quality: CGFloat)
}

struct ImageDataProvider {
    func data(from image: UIImage, withFormat format: ImageFormat) -> Result<Data> {
        switch format {
        case .jpeg(let quality):
            return generateJPEGRepresentationData(from: image, compressionQuality: quality)
        case .png:
            return generatePNGRepresentationData(from: image)
        }
    }
    
    private func generateJPEGRepresentationData(from image: UIImage, compressionQuality: CGFloat) -> Result<Data> {
        guard let data = UIImageJPEGRepresentation(image, compressionQuality) else {
            let error = ImageAPIError.failedGettingDataRepresentation(.jpeg(quality: compressionQuality))
            return .fail(error)
        }
        return .success(data)
    }
    
    private func generatePNGRepresentationData(from image: UIImage) -> Result<Data> {
        guard let data = UIImagePNGRepresentation(image) else {
            let error = ImageAPIError.failedGettingDataRepresentation(.png)
            return .fail(error)
        }
        return .success(data)
    }
}

/* 3 */
struct DiskManager {
    
    private let fileManager = FileManager.default
    
    var saveDirectory: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var saveDirectoryContents: [String] {
        var contents = [String]()
        do {
            contents = try fileManager.contentsOfDirectory(atPath: saveDirectory.relativePath)
            
        } catch let error {
            print(error)
        }
        return contents
    }
    
    func getSavedImageURLs() -> [URL] {
        return saveDirectoryContents.flatMap {
            return saveDirectory.appendingPathComponent($0)
            }
            .filter {
                $0.absoluteString.hasSuffix(".jpg")
        }
    }
    
    func removeSavedImages() {
        getSavedImageURLs().forEach {
            if $0.absoluteString.hasSuffix(".jpg") {
                try? fileManager.removeItem(at: $0)
            }
        }
    }
}
```

### Usage:
```swift
class ViewController: UIViewController {
    
    @IBOutlet weak var wikiURLsPickerView: UIPickerView!
    @IBOutlet weak var savedImagesPickerView: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    
    private let imageAPIFacade = ImageAPIFacade()
    private let remoteImagePickerHandler = RemoteImagePickerHandler()
    private let savedImagePickerHandler = SavedImagePickerHandler()
    
    private var pickedRemoteImageURL: URL!
    private var pickedSavedImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cleanup()
        setup()
        updateSavedImagesPicker()
    }
    
    private func setup() {
        imageView.contentMode = .scaleAspectFill
        pickedRemoteImageURL = remoteImagePickerHandler.defaultImagePickerURL()
        wikiURLsPickerView.delegate = remoteImagePickerHandler
        wikiURLsPickerView.dataSource = remoteImagePickerHandler
        savedImagesPickerView.delegate = savedImagePickerHandler
        savedImagesPickerView.dataSource = savedImagePickerHandler
        remoteImagePickerHandler.delegate = self
        savedImagePickerHandler.delegate = self
    }
    
    private func cleanup() {
        imageAPIFacade.removeSavedImages()
    }
    
    private func updateSavedImagesPicker() {
        savedImagePickerHandler.urls = imageAPIFacade.getSavedImageURLs()
        savedImagesPickerView.reloadAllComponents()
        if savedImagePickerHandler.urls.isEmpty == false {
            pickedSavedImageURL =  savedImagePickerHandler.urls.first
        }
    }
}

extension ViewController {
    @IBAction func saveRemoteImageToDiskDidTouchUpInside(_ sender: UIButton) {
        let name = pickedRemoteImageURL.imageName()
        let format: ImageFormat = .jpeg(quality: 0.8)
        imageAPIFacade.saveRemoteImage(url: pickedRemoteImageURL, name: name, format: format, shouldOverwrite: true, callback: { [weak self] result in
            print(result.debugDescription)
            self?.updateSavedImagesPicker()
        })
    }
    
    @IBAction func showSavedImageDidTouchUpInside(_ sender: UIButton) {
        guard let url = pickedSavedImageURL else {
            return
        }
        imageView.image = imageAPIFacade.retrieveSavedImage(with: url)
    }
}

extension ViewController: PickerViewDelegate {
    func pickerViewDidSelect(row: Int, pickerType: PickerImagesType) {
        switch pickerType {
        case .remote:
            let remoteURL = remoteImagePickerHandler.getURL(for: row)
            if let url = remoteURL { pickedRemoteImageURL = url }
        case .local:
            pickedSavedImageURL = savedImagePickerHandler.urls[row]
        }
    }
}
```

## Factory Method (Virtual Constructor)
 > Factory Method is used when there are several classes that implement a common protocol or share a common base class.
 This pattern allows implementation subclasses to provide specializations without requiring the components that rely on them
 to know any details of those classes and how they relate to each other.

#### Resources to check:
 
[Class Factory Methods](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/ClassFactoryMethods/ClassFactoryMethods.html#//apple_ref/doc/uid/TP40010810-CH8-SW1) in Apple's Cocoa Encyclopedia. </br> 
    [Factory Method](https://en.wikipedia.org/wiki/Factory_method_pattern)  in Wikipedia. </br>

#### Cocoa/CocoaTouch Adaptation: </br> 
Convenience class-methods in NSNumber.

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

## Abstract Factory 
> Allows a calling component to obtain a family or group of related objects without needing to know which classes were used to create them. </br>

#### Cocoa/CocoaTouch Adaptation:
Not sure which cocoa/cocoa touch classes adopt the pattern (many adopt the Class Cluster which is very similar but can only be implemented in Objective-C though). </br>

### Implementation
```swift

import Foundation

enum Architecture {
    case enginola
    case ember
}

protocol CPU {}

class EmberCPU: CPU {}
class EnginolaCPU: CPU {}

protocol MMU {}

class EmberMMU: MMU {}
class EnginolaMMU: MMU {}

protocol AbstractFactory {
    func getFactory(_ arch: Architecture) -> ToolKitFactory
}

protocol ToolKitFactory {
    func createCPU() -> CPU
    func createMMU() -> MMU
}

final class HardwareFactory: AbstractFactory {
    private let emberToolkit = EmberToolkit()
    private let enginolaToolkit = EnginolaToolkit()
    
    func getFactory(_ arch: Architecture) -> ToolKitFactory {
        switch arch {
        case .ember:
            return emberToolkit
        case .enginola:
            return enginolaToolkit
        }
    }
}

final class EmberToolkit: ToolKitFactory {
    func createCPU() -> CPU {
        return EmberCPU()
    }
    
    func createMMU() -> MMU {
        return EmberMMU()
    }
}

final class EnginolaToolkit: ToolKitFactory {
    func createCPU() -> CPU {
        return EnginolaCPU()
    }
    
    func createMMU() -> MMU {
        return  EnginolaMMU()
    }
}
```

### Usage:
```swift
let abstractFactory: AbstractFactory = HardwareFactory()

let emberCPU = abstractFactory.getFactory(.ember).createCPU()
let emberMMU = abstractFactory.getFactory(.ember).createMMU()

let enginolaCPU = abstractFactory.getFactory(.enginola).createCPU()
let enginolaMMU = abstractFactory.getFactory(.enginola).createMMU()
```

## Class Cluster
 > Architecture that groups a number of private, concrete subclasses under a public, abstract superclass (pattern based on Abstract Factory).
Class cluster is actually a specific implementation of a factory but the initialiser is used instead of the Factory Method to decide what instance to return. Also Factories are used to create instances implementing a protocol while Class Cluster is only suitable for creation of subclasses of an Abstract Class.
 
However Class Clusters can only be implemented in Objective-C. Unlike Objective-C (where we can just replace 'self' in init method, and return proper subclass object based on the input type) when we call init method of a class we get only instance of that particular class in Swift...so we can't rely on the init method to construct a Class Cluster. A substitution whould be to use a Factory instead.
 
#### Cocoa/CocoaTouch Adaptation: </br> 
NSNumber, NSString, NSArray, NSDictionary, NSData. </br>

#### Resources to check:
[Class Cluster](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html#//apple_ref/doc/uid/TP40010810-CH4) in Apple's Cocoa Encyclopedia. </br>
[Class Cluster](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/ClassCluster.html#//apple_ref/doc/uid/TP40008195-CH7-SW1) in Apple's Cocoa DevPedia. </br>


## Builder
> Builder pattern separates the construction of a complex object from its representation so that the same construction process can create different representations. Builder pattern is not too much adopted in Objective-C/Swift.

#### Cocoa/CocoaTouch Adaptation: </br> 
None. 
> “I think all of the famous GoF patterns exist within Cocoa, but many are either trivially implemented or made less necessary thanks to Objective-C. For example, the Cocoa convention of two stage allocation and initialization makes the GoF Abstract factory and Builder patterns trivial.” - Eric Buck (author of Cocoa Design Patterns)

### Implementation 1 (Simple & Swifty)

```swift
protocol ComponentStyle {
    var backgroundColor: UIColor { get set }
    var borderColor: UIColor { get set }
    var borderWidth: CGFloat { get set }
    var size: CGSize { get set }
}

class TabStyle: ComponentStyle {
    var backgroundColor: UIColor = .white
    var borderColor: UIColor = .black
    var borderWidth: CGFloat = 2.0
    var size: CGSize = CGSize(width: 100.0, height: 54.0)
    
    init(build: (TabStyle) -> Void) { build(self) }
    
    private init() {}
}
```

### Usage:
```swift
let tabStyle = TabStyle(build: {
    $0.backgroundColor = .yellow
    $0.borderColor = .clear
    $0.borderWidth = 0.0
    $0.size = CGSize(width: 80, height: 40)
})
```

### Implementation 2 (Classic)
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

#### Cocoa/CocoaTouch Adaptation: </br> 
FileManager, URLSession, Notification, UserDefaults, ProcessInfo (Foundation), UIApplication and UIAccelerometer (UIKit), SKPaymentQueue (StoreKit) etc. </br>

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

#### Cocoa/CocoaTouch Adaptation: </br> 
UIKit's tableView/collectionView reusable cells use Object Pool pattern (not sure how it's implemented though, no source code to look at). </br>
The dequeueReusableCellWithIdentifier method combines Object Pool and Factory Method patterns. </br>

More: </br>
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

## Decorator
> Pattern allows behavior to be added to an individual object, either statically or dynamically, without affecting the behavior of other objects from the same class. </br>

#### Cocoa/CocoaTouch Adaptation: </br> 
NSAttributedString, NSScrollView, and UIDatePicker </br>

[Decorator](https://en.wikipedia.org/wiki/Decorator_pattern) on Wikipedia. </br>

### Implementation 
```swift
struct Article {
    let id: String
    let name: String
    let data: [String: String]
    let rating: Int
    let viewCount: Int
}

enum ArticleType {
    case blog, news
}

enum Result<T> {
    case result(T); case error(Error)
}

protocol HTTPClient {
    /* http client interface...
     */
}

class ArticleAPIClient: HTTPClient {
    /* http client implementation (with URLSession for ex.)
     * init with base url, GET/POST/UPDATE...standard stuff
     */
}

protocol ArticleServiceProtocol {
    var client: HTTPClient { get }
    /* For demonstration of this pattern service wiil just download data */
    func load(byID id: String) -> Result<Article>
    func load(withQuery query: String) -> Result<[Article]>
    /*
    func create(article: Article) -> Result<Bool>
    func remove(byID id: String) -> Result<Bool>
    func update(byID id: String, article: Article) -> Result<Bool>
     */
}

class NewsArticleService: ArticleServiceProtocol {
    let client: HTTPClient
    
    init(with httpClient: HTTPClient) {
        self.client = httpClient
    }
    
    func load(withQuery query: String) -> Result<[Article]> {
        return .result([])
    }
    
    func load(byID id: String) -> Result<Article> {
        let dummyArticle = Article(id: "news.article.000001", name: "Tech News 01", data: [:], rating: 100, viewCount: 300)
        return .result(dummyArticle)
    }
}

class BlogArticleService: ArticleServiceProtocol {
    let client: HTTPClient
    
    init(with httpClient: HTTPClient) {
        self.client = httpClient
    }
    
    func load(byID id: String) -> Result<Article> {
        let dummyArticle = Article(id: "blog.article.000020", name: "Blog Article 20", data: [:], rating: 100, viewCount: 300)
        return .result(dummyArticle)
    }
    
    func load(withQuery query: String) -> Result<[Article]> {
        return .result([])
    }
}

enum ArticleCount: Int {
    case ten = 10; case twenty = 20; case fifty = 50
}

enum ArticleGradationType {
    case rating, views
}

protocol TopArticleDecoratorProtocol {
    func loadTopRated(count: ArticleCount) -> Result<[Article]>
    func loadMostViewed(count: ArticleCount) -> Result<[Article]>
}

class TopBlogArticleServiceDecorator: TopArticleDecoratorProtocol {
    
    let base: BlogArticleService
    
    init(with baseService: BlogArticleService) {
        self.base = baseService
    }
    
    func loadTopRated(count: ArticleCount) -> Result<[Article]> {
        let query = SQLConstructor.makeQuery(object: "BlogArticle", orderBy: .rating, limit: count)
        return base.load(withQuery: query)
    }
    
    func loadMostViewed(count: ArticleCount) -> Result<[Article]> {
        let query = SQLConstructor.makeQuery(object: "BlogArticle", orderBy: .views, limit: count)
        return base.load(withQuery: query)
    }
}

class TopNewsArticleServiceDecorator: TopArticleDecoratorProtocol {
    
    let base: NewsArticleService
    
    init(with baseService: NewsArticleService) {
        self.base = baseService
    }
    
    func loadTopRated(count: ArticleCount) -> Result<[Article]> {
        let query = SQLConstructor.makeQuery(object: "NewsArticle", orderBy: .rating, limit: count)
        return base.load(withQuery: query)
    }
    
    func loadMostViewed(count: ArticleCount) -> Result<[Article]> {
        let query = SQLConstructor.makeQuery(object: "NewsArticle", orderBy: .views, limit: count)
        return base.load(withQuery: query)
    }
}

struct SQLConstructor {
    static func makeQuery(object: String, orderBy gradationType: ArticleGradationType, limit: ArticleCount) -> String {
        // construct something like:
        return "SELECT \(object) FROM ... ORDER BY \(gradationType) LIMIT \(limit)"
    }
}

let articleAPIClient: HTTPClient = ArticleAPIClient()

let baseNewsArticleService = NewsArticleService(with: articleAPIClient)
let baseBlogArticleService = BlogArticleService(with: articleAPIClient)
```

### Usage:
```swift
// lets get some top stuff:
let topNewsService = TopNewsArticleServiceDecorator(with: baseNewsArticleService)
let topBlogService = TopBlogArticleServiceDecorator(with: baseBlogArticleService)

// top news articles
topNewsService.loadTopRated(count: .ten)
topNewsService.loadMostViewed(count: .twenty)

// top blog posts
topBlogService.loadTopRated(count: .ten)
topBlogService.loadMostViewed(count: .fifty)
```

## Prototype
> Used to instantiate a new object by copying all of the properties of an existing object, creating an independent clone. </br>

#### Cocoa/CocoaTouch Adaptation: </br> 
... </br>


### Implementation 
```swift
class Person: NSObject {
    enum Status {
        case initital, onTheWay, arrived, canceled
    }
    
    let name: String
    let photo: UIImage?
    var status: Status = .initital
    
    init(name: String, photo: UIImage?, status: Status = .initital) {
        self.name = name; self.photo = photo;
        super.init()
    }
}

extension Person: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Person(name: name, photo: photo?.copy() as? UIImage, status: status)
    }
}

class Appointment: NSObject {
    let place: String
    let time: Date
    let people: [Person]
    
    init(place: String, time: Date, people: [Person]) {
        self.place = place; self.time = time; self.people = people
        super.init()
    }
}

extension Appointment: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copiedPeople = people.flatMap { return $0.copy() as? Person }
        return Appointment(place: place, time: time, people: copiedPeople)
    }
}
```

### Usage:
```swift
/* The examples doesn't look legit lol :P */
let people = [ Person.init(name: "Petro", photo: nil),
               Person.init(name: "Maria", photo: nil),
               Person.init(name: "Stepan", photo: nil, status: .canceled) ]


/* Prototype */
let appointment = Appointment(place: "Lviv, Stepana Bandery str.", time: Date.distantFuture, people: people)

/* Cloned object */
let clone = appointment.copy() as? Appointment
```
