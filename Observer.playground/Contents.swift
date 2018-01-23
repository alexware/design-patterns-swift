
import Foundation

final class NotificationHandler<P> {
    weak var subject: AnyObject?
    let action: (AnyObject) -> (P) -> Void
    init(subject: AnyObject, action: @escaping (AnyObject) -> (P) -> Void) {
        self.subject = subject
        self.action = action
    }
}

final class Observer<P> {
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


/* Usage: */

/* Let's have some fun! We will create 2 classes:
 * Girl class changes clothes and Guy is observing the changes lol
 */

final class Girl {
    enum State {
        case dressedNormally, dressedForRoleGames, naked
    }
    
    private var observers = Observer<State>()
    
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

