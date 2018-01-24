
import UIKit

final class WeakContainer {
    weak var value: AnyObject?
    init(_ value: AnyObject) {
        self.value = value
    }
}

extension WeakContainer: Equatable {
    static func == (lhs: WeakContainer, rhs: WeakContainer) -> Bool {
        return lhs.value === rhs.value
    }
}

final class MulticastDelegate<T> {
    private var delegates = [WeakContainer]()
    
    var count: Int {
        return delegates.count
    }
    
    var isEmpty: Bool {
        return delegates.count == 0
    }
    
    func add(_ delegate: T) {
        if Mirror(reflecting: delegate)
            .subjectType is AnyClass {
            let wrappedDelegate = WeakContainer(delegate as AnyObject)
            
            guard delegates.index(of: wrappedDelegate) == nil else {
                return
            }
            delegates.append(wrappedDelegate)
        }
    }
    
    func remove(_ delegate: T) {
        if Mirror(reflecting: delegate)
            .subjectType is AnyClass {
            let wrappedDelegate = WeakContainer(delegate as AnyObject)
        
            guard let index = delegates.index(of: wrappedDelegate) else {
                return
            }
            delegates.remove(at: index)
        }
    }
    
    func invoke(_ invocation: (T) -> ()) {
        for delegate in delegates {
            if let delegate = delegate as? T {
                invocation(delegate)
            }
        }
    }
}

