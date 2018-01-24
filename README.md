# Design Patterns in Swift 4 ;]

### Table of Implementations:

👮🏼 Behavioral              | 👷🏼 Creational      | 👨🏼‍🏭 Structural    | 👨🏼‍🎓 Non-GOF
------------            | -------------   | ------------- | -------------
[Chain of Responsibility](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/ChainOfResponsibility/ChainOfResponsibility.playground/Contents.swift) |[Factory Method](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/FactoryMethod/FactoryMethod.playground/Contents.swift)   | [Facade](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Facade/Facade)        |  [Dependency Injection](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/DependencyInjection/DependencyInjection.playground/Contents.swift)
[Strategy](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Strategy/Strategy.playground/Contents.swift)                |[Abstract Factory](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/AbstractFactory/AbstractFactory.playground/Contents.swift) | [Decorator](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Decorator/Decorator.playground/Contents.swift)     |  [Object Pool](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/ObjectPool/ObjectPool.playground/Contents.swift)
[Command](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Command/Command)                 |[Singleton](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Singleton/Singleton.playground/Contents.swift)        | [Proxy](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Proxy/Proxy.playground/Contents.swift)         |  Class Cluster 
[State](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/State/State.playground/Contents.swift)                   |[Builder](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Builder/Builder.playground/Contents.swift)          | [Adapter](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Adapter/Adapter.playground/Contents.swift)       |  [Private Class Data](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/PrivateClassData/PrivateClassData.playground/Contents.swift)
[Observer](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Observer/Observer.playground/Contents.swift)                |[Prototype](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Prototype/Prototype.playground/Contents.swift)        |               |  [Delegate](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Delegate/Delegate.playground/Contents.swift)
[Memento](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Memento/Memento.playground/Contents.swift)                 |                 |               |  [Multicast Delegate](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/MulticastDelegate/MulticastDelegate.playground/Contents.swift)
[Iterator](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Iterator/Iterator.playground/Contents.swift)                |                 |               |  [DataSource](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/DataSource/DataSource.playground/Contents.swift)


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

## Chain Of Responsibility
> Used to chain the receiving objects and pass the request along the chain until an object handles it.

#### Cocoa/CocoaTouch Adaptation: </br>
UIResponder/NSResponder </br>

### Implementation
```swift
enum EngineerLevel: Int {
    case junior = 0, middle, senior
}

extension EngineerLevel: Comparable {
    static func < (lhs: EngineerLevel, rhs: EngineerLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func == (lhs: EngineerLevel, rhs: EngineerLevel) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

protocol JiraItem {
    var code: String { get }
    var description: String { get }
    var levelOfCompetency: EngineerLevel { get }
    var completed: Bool { get }
    func close(_ comment: String)
}

final class Task: JiraItem {
    let code: String
    let description: String
    let levelOfCompetency: EngineerLevel
    var completed: Bool {
        return _completed
    }
    
    private var _completed: Bool = false
    
    init(code: String, description: String, levelOfCompetency: EngineerLevel) {
        self.code = code
        self.description = description
        self.levelOfCompetency = levelOfCompetency
    }
    
    func close(_ message: String) {
        _completed = true
        print(message)
    }
}

final class SoftwareEngineer {
    let name: String
    let level: EngineerLevel
    var isDeveloping: Bool = false
    
    init(name: String, level: EngineerLevel) {
        self.name = name
        self.level = level
    }
    
    func resolve(_ task: JiraItem) -> Bool {
        guard !isDeveloping else {
            assert(false, "Something wrong here! Developer is working on another ticket.")
        }
        guard task.levelOfCompetency <= level else {
            assert(false, "Something wrong here! Developer is not qualified enough.")
        }
        isDeveloping = true
        print("\(name), iOS \(level) Developer has started \(task.code).")
        task.close("\(task.description) (\(task.code)) was merged into Dev branch.")
        return true
    }
}

final class EngineeringTeam {
    var level: EngineerLevel
    var engineers: [SoftwareEngineer]
    var higherCompetencyTeam: EngineeringTeam?
    
    init(engineers: [SoftwareEngineer], level: EngineerLevel, higherCompetencyTeam: EngineeringTeam?) {
        self.engineers = engineers
        self.level = level
        self.higherCompetencyTeam = higherCompetencyTeam
    }
    
    func tryToResolve(_ task: JiraItem) -> Bool {
        if task.levelOfCompetency > level || !hasAvailableSoftwareEngineers {
            if let team = higherCompetencyTeam {
                return team.tryToResolve(task)
            } else {
                print("No team member available.")
                return false
            }
        } else {
            if let availableSoftwareEngineer = availableSoftwareEngineer {
                return availableSoftwareEngineer.resolve(task)
            }
            assert(false, "Something went wrong!")
        }
    }
    
    private var availableSoftwareEngineer: SoftwareEngineer? {
        return engineers.filter({ $0.isDeveloping == false }).first
    }
    
    private var hasAvailableSoftwareEngineers: Bool {
        return engineers.filter({ $0.isDeveloping == false }).count > 0
    }
}

final class ITOutsorcingCompany {
    private var engineers: EngineeringTeam
    
    init(engineers: EngineeringTeam) {
        self.engineers = engineers
    }
    
    func resolve(_ task: JiraItem) -> Bool {
        return engineers.tryToResolve(task)
    }
}
```

### Usage
```swift
/* Lets build the team: */

/* Here comes the cavalry */
let s1 = SoftwareEngineer(name: "Alex", level: .senior)
let s2 = SoftwareEngineer(name: "Volodya", level: .senior)
let s3 = SoftwareEngineer(name: "Petro", level: .senior)

let seniors = EngineeringTeam(engineers: [s1, s2, s3], level: .senior, higherCompetencyTeam: nil)

/* Ah, the work horses. Let's pop some tickets! */
let m1 = SoftwareEngineer(name: "Andrii", level: .middle)
let m2 = SoftwareEngineer(name: "Vitalii", level: .middle)
let m3 = SoftwareEngineer(name: "Dima", level: .middle)

let middles = EngineeringTeam(engineers: [m1, m2, m3], level: .middle, higherCompetencyTeam: seniors)

/* Juniors fresh from galera's 'Base Camp' to sink the ship...Ahoy! */
let j1 = SoftwareEngineer(name: "Kyrylo", level: .junior)
let j2 = SoftwareEngineer(name: "Mykyta", level: .junior)
let j3 = SoftwareEngineer(name: "Pavlo", level: .junior)

let juniors = EngineeringTeam(engineers: [j1, j2, j3], level: .junior, higherCompetencyTeam: middles)

/* Let's throw in some work for the guys: */
let backlog: [JiraItem] = [
    Task(code: "GAL-757", description: "Fix layout", levelOfCompetency: .junior),
    Task(code: "GAL-990", description: "Custom network protocol implementation", levelOfCompetency: .senior),
    Task(code: "GAL-932", description: "Fix database concurrency issue", levelOfCompetency: .senior),
    Task(code: "GAL-1003", description: "Develop complex UI component", levelOfCompetency: .middle),
    Task(code: "GAL-994", description: "Fix crash on tableView", levelOfCompetency: .junior),
    Task(code: "GAL-790", description: "Change button color", levelOfCompetency: .junior),
    Task(code: "GAL-852", description: "Fix UI component offsets", levelOfCompetency: .junior),
    Task(code: "GAL-1001", description: "Integrate Analitics", levelOfCompetency: .middle)
]

/* Work!  */
backlog.forEach {
    
    /* Will resolve task or find more competent mate and hand it over */
    juniors.tryToResolve(task)
}
```

## Strategy
> Used to create classes that can be extended without modification, basically switching or adding algorithm. </br> 

#### Cocoa/CocoaTouch Adaptation: </br> 
UITableView, UICollectionView.
UITableView/UICollectionView is using UITableViewUICollectionViewDataSource/UICollectionViewDataSource to define the strategy for generating rows/columns and providing data.

### Implementation </br> 
```swift
import Foundation

protocol Strategy {
    func execute(collection: [Int]) -> [Int]
}

/* Shuffle concrete strategies */
final class BasicShuffleStrategy: Strategy {
    func execute(collection: [Int]) -> [Int] {
        var temp = [Int]()
        var input = collection
        while !input.isEmpty {
            let index = random(input.count)
            let element = input.remove(at: index)
            temp.append(element)
        }
        return temp
    }
}

final class KnuthShuffleStrategy: Strategy {
    func execute(collection: [Int]) -> [Int] {
        var result = collection
        for i in stride(from: collection.count - 1, through: 1, by: -1) {
            let j = random(i + 1)
            if i != j {
                result.swapAt(i, j)
            }
        }
        return result
    }
}

/* helper */
func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

final class Shuffler {
    private var collection: [Int]
    
    init(collection: [Int]) {
        self.collection = collection
    }
    
    func shuffle(strategy: Strategy) -> [Int] {
        return strategy.execute(collection: collection)
    }
}
```

### Usage:
```swift
let numbers = [2, 5, 6, 30, 75, 2, 9, 45]
let shuffler = Shuffler(collection: numbers)

let basicShuffleStrategy = BasicShuffleStrategy()
let knuthShuffleStrategy = KnuthShuffleStrategy()

/* switching algorithms */
let shuffled1 = shuffler.shuffle(strategy: basicShuffleStrategy)
let shuffled2 = shuffler.shuffle(strategy: knuthShuffleStrategy)
```

## Observer
> Defines a one-to-many relationship so that when one object changes state, the others are notified and updated automatically. </br>

#### Cocoa/CocoaTouch Adaptation:
NotificationCenter/NSNotificationCenter, Key-Value Observing </br>

### Implementation
```swift
import Foundation

final class NotificationHandler<P> {
    weak var subject: AnyObject?
    let action: (AnyObject) -> (P) -> Void
    init(subject: AnyObject, action: @escaping (AnyObject) -> (P) -> Void) {
        self.subject = subject
        self.action = action
    }
}

final class ObserverSet<P> {
    private var handlers = [NotificationHandler<P>]()
    private var queue = DispatchQueue(label: "com.zayats.oleh.observer", attributes: [])
    
    init() {}
    
    func attach(_ closure: @escaping (P) -> Void) -> NotificationHandler<P> {
        return attach(self, { _ in closure })
    }
    
    private func attach<T: AnyObject>(_ subject: T,
                                      _ closure: @escaping (T) -> (P) -> Void) -> NotificationHandler<P> {
        
        let handler = NotificationHandler<P>(subject: subject, action: { closure($0 as! T) })
        queue.sync { handlers.append(handler) }
        return handler
    }
    
    func detach(_ handler: NotificationHandler<P>) {
        queue.sync { handlers = handlers.filter { $0 !== handler } }
    }
    
    func notify(_ params: P) {
        var toPerform = [(P) -> Void]()
        queue.sync {
            handlers.forEach {
                if let subject: AnyObject = $0.subject {
                    toPerform.append($0.action(subject))
                }
            }
            handlers = handlers.filter { $0.subject != nil }
        }
        toPerform.forEach { $0(params) }
    }
}
```

### Usage:
```swift
/* Let's have some fun! We will create 2 classes:
 * Girl class changes clothes and Guy is observing the changes lol
 */

/* the subject, maintains a list of its dependents, called observers, and notifies 
 * them automatically of any state changes 
 */
final class Girl {
    enum State {
        case dressedNormally, dressedForRoleGames, naked
    }
    
    private var observers = ObserverSet<State>()
    
    var state: State = .dressedNormally {
        didSet {
            print("  Girl: <\(state)>")
            observers.notify(state)
        }
    }
    
    init() {}
    
    func addObserverHandler(_ handler: @escaping (State) -> Void) -> NotificationHandler<State> {
        return observers.attach(handler)
    }
    
    func removeObserverHandler(_ handler: NotificationHandler<State>) {
        observers.detach(handler)
    }
}

/* the observer */
final class Guy {
    private let girl: Girl
    private var handler: NotificationHandler<Girl.State>?
    private let name: String
    
    init(name: String, subject: Girl) {
        self.girl = subject
        self.name = name
    }
    
    func startObserving() {
        guard handler == nil else {
            return
        }
        
        handler = girl.addObserverHandler { state in
            switch state {
            case .dressedNormally:
                print("\(self.name): Nothing to see here.")
            case .dressedForRoleGames:
                print("\(self.name): Role games? This is interesting!")
            case .naked:
                print("\(self.name): Alert! The girl is naked!")
            }
        }
    }
    
    func stopObserving() {
        guard let handler = self.handler else { return }
        girl.removeObserverHandler(handler)
        print("\(self.name): I'm out!")
    }
}

/* Action! */

let girl = Girl()
let boris = Guy(name: " Boris", subject: girl)
let victor = Guy(name: "Victor", subject: girl)

boris.startObserving()
victor.startObserving()

girl.state = .naked
girl.state = .dressedForRoleGames
girl.state = .dressedNormally

boris.stopObserving()

girl.state = .dressedForRoleGames
girl.state = .dressedNormally
```

## Abstract Factory 
> Allows a calling component to obtain a family or group of related objects without needing to know which classes were used to create them. </br>

#### Cocoa/CocoaTouch Adaptation:
Not sure which cocoa/cocoa touch classes adopt the pattern (many adopt the Class Cluster which is very similar but can only be implemented in Objective-C though). </br>

### Implementation
```swift

import Foundation

enum EngineeringLevel {
    case junior, middle, senior
}

protocol SoftwareEngineerCompetencyMatrix {}

class JuniorSEMatrix: SoftwareEngineerCompetencyMatrix {}
class MiddleSEMatrix: SoftwareEngineerCompetencyMatrix {}
class SeniorSEMatrix: SoftwareEngineerCompetencyMatrix {}

protocol QACompetencyMatrix {}

class JuniorQAMatrix: QACompetencyMatrix {}
class MiddleQAMatrix: QACompetencyMatrix {}
class SeniorQAMatrix: QACompetencyMatrix {}

protocol CompetencyMatrix {
    func softwareEngineerMatrix() -> SoftwareEngineerCompetencyMatrix
    func qaEngineerMatrix() -> QACompetencyMatrix
}

/* Abstract Factory */
protocol Company {
    func resources(_ level: EngineeringLevel) -> CompetencyMatrix
}

final class Facebook: Company {
    private let juniorMatrix = JuniorMatrix()
    private let middleMatrix = MiddleMatrix()
    private let seniorMatrix = SeniorMatrix()
    
    /* Factory Method */
    func resources(_ level: EngineeringLevel) -> CompetencyMatrix {
        switch level {
        case .junior:
            return juniorMatrix
        case .middle:
            return middleMatrix
        case .senior:
            return seniorMatrix
        }
    }
}

final class JuniorMatrix: CompetencyMatrix {
    func softwareEngineerMatrix() -> SoftwareEngineerCompetencyMatrix {
        return JuniorSEMatrix()
    }
    
    func qaEngineerMatrix() -> QACompetencyMatrix {
        return JuniorQAMatrix()
    }
}

final class MiddleMatrix: CompetencyMatrix {
    func softwareEngineerMatrix() -> SoftwareEngineerCompetencyMatrix {
        return MiddleSEMatrix()
    }
    
    func qaEngineerMatrix() -> QACompetencyMatrix {
        return MiddleQAMatrix()
    }
}

final class SeniorMatrix: CompetencyMatrix {
    func softwareEngineerMatrix() -> SoftwareEngineerCompetencyMatrix {
        return SeniorSEMatrix()
    }
    
    func qaEngineerMatrix() -> QACompetencyMatrix {
        return SeniorQAMatrix()
    }
}
```

### Usage:
```swift
let facebook: Company = Facebook()

/* competency info */
let seniorQA = facebook.resources(.senior).qaEngineerMatrix()
let midSE = facebook.resources(.middle).softwareEngineerMatrix()
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
 > Used when there are several classes that implement a common protocol or share a common base class.
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

## Class Cluster
 > Groups a number of private, concrete subclasses under a public, abstract superclass (pattern based on Abstract Factory).
Class cluster is actually a specific implementation of a factory but the initialiser is used instead of the Factory Method to decide what instance to return. Also Factories are used to create instances implementing a protocol while Class Cluster is only suitable for creation of subclasses of an Abstract Class.
 
However Class Clusters can only be implemented in Objective-C. Unlike Objective-C (where we can just replace 'self' in init method, and return proper subclass object based on the input type) when we call init method of a class we get only instance of that particular class in Swift...so we can't rely on the init method to construct a Class Cluster. A substitution whould be to use a Factory instead.
 
#### Cocoa/CocoaTouch Adaptation: </br> 
NSNumber, NSString, NSArray, NSDictionary, NSData. </br>

#### Resources to check:
[Class Cluster](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html#//apple_ref/doc/uid/TP40010810-CH4) in Apple's Cocoa Encyclopedia. </br>
[Class Cluster](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/ClassCluster.html#//apple_ref/doc/uid/TP40008195-CH7-SW1) in Apple's Cocoa DevPedia. </br>


## Builder
> Separates the construction of a complex object from its representation so that the same construction process can create different representations. Builder pattern is not too much adopted in Objective-C/Swift.

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
> Used when there's a need for caching a 'heavy' object (has an expensive initialization).

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
> Allows behavior to be added to an individual object, either statically or dynamically, without affecting the behavior of other objects from the same class. </br>

#### Cocoa/CocoaTouch Adaptation: </br> 
NSAttributedString, NSScrollView, and UIDatePicker </br>

[Decorator](https://en.wikipedia.org/wiki/Decorator_pattern) on Wikipedia. </br>

### Implementation 
```swift
import UIKit

enum ProductCategory {
    case techMobile
    case techAccessories
    case techComputerAndOffice
    case techConsumerElectronics
    case techHomeImprovement
    case clothesWomen
    case clothesMen
    case clothesKids
    case toys
}

protocol ProductProtocol {
    var name: String { get }
    var description: String { get }
    var category: ProductCategory { get }
    var price: Double { get }
}

class Product: ProductProtocol {
    
    let name: String
    let category: ProductCategory
    
    var description: String {
        get { return _description }
    }
    
    var price: Double {
        get { return _price }
    }
    
    private let _description: String
    private let _price: Double
    
    init(name: String, description: String, category: ProductCategory, price: Double) {
        self.name = name
        self.category = category
        self._description = description
        self._price = price
    }
}

class ProductPriceDecorator: Product {
    let baseProduct: Product
    
    init(_ baseProduct: Product) {
        self.baseProduct = baseProduct
        super.init(name: baseProduct.name, description: baseProduct.description, category: baseProduct.category, price: baseProduct.price)
    }
}

class ProductBlackFridayDecorator: ProductPriceDecorator {
    override var description: String {
        return baseProduct.description + " This is Black Friday! Discount: \(baseProduct.price - price) $"
    }
    
    override var price: Double {
        var price = baseProduct.price

        switch category {

        case .techMobile:
            price = price * 0.95

        case .techAccessories:
            price = price * 0.80

        case .techComputerAndOffice, .techConsumerElectronics, .techHomeImprovement:
            price = price * 0.98

        case .clothesWomen:
            price = price * 0.70

        case .clothesMen:
            price = price * 0.95

        case .clothesKids:
            price = price * 0.85

        case .toys:
            price = price * 0.94
        }
        return price
    }
}

class ProductCyberMondayDecorator: ProductPriceDecorator {
    override var description: String {
        return baseProduct.description + " Discounts for ALL! Happy Cyber Monday! Discount: \(baseProduct.price - price) $"
    }
    
    override var price: Double {
        var price = baseProduct.price

        switch category {

        case .techMobile:
            price = price * 0.90

        case .techAccessories:
            price = price * 0.65

        case .techComputerAndOffice, .techConsumerElectronics:
            price = price * 0.86

        case .techHomeImprovement:
            price = price * 0.95

        default:
            break
        }
        return price
    }
}
```

### Usage:
```swift
let iPhoneX = Product(name: "iPhoneX", description: "Has animated 'shit' emoji!", category: .techMobile, price: 1800)
let iPhoneXBlackFridayDecorator = ProductBlackFridayDecorator(iPhoneX)
let iPhoneXCyberMondayDecorator = ProductCyberMondayDecorator(iPhoneX)

let blPrice = iPhoneXBlackFridayDecorator.price
let blDescription = iPhoneXBlackFridayDecorator.description

let cmPrice = iPhoneXCyberMondayDecorator.price
let cmDescription = iPhoneXCyberMondayDecorator.description
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
