
import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {
    func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case let .success(value):
            return Result<U>.success(transform(value))
        case let .failure(error):
            return Result<U>.failure(error)
        }
    }
}
