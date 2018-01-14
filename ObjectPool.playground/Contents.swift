
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
