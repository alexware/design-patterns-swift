
import Foundation

/* 1. */

/* Container (enumaration) */

// Note: 'Result' is similar to Optional/Either, but returns Error instead, so that you know why a request failed
enum Result<T> {
    case success(T)
    case failure(Error)
}

/* map implementation */
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

/* 2 */

/* functional style Functor */

infix operator <^>

func <^><T, U>(_ transform: (T) -> U, _ input: [T]) -> [U] {
    return input.map(transform)
}

let toInteger: (String) -> Int = { return Int($0)! }
let collectionOfStrings = ["10", "1000", "40"]

let collectionOfIntegers = toInteger <^> collectionOfStrings

// Caution (!): Exercise restraint when using custom operators with exotic symbols
// they are hard to type, and therefore hard to use.

