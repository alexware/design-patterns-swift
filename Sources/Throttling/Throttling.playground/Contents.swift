
import Foundation

/* Implementation: */

final class Throttler {
    private let queue: DispatchQueue = .global(qos: .background)
    private var work: DispatchWorkItem?
    private var throttleInterval: Double
    private var lastRun: Date = .distantPast
    
    private var currentDelay: Double {
        return (Date().timeIntervalSince(lastRun) > throttleInterval) ? 0.0 : throttleInterval
    }
    
    init(_ intervalInSeconds: Double) {
        self.throttleInterval = intervalInSeconds
    }
    
    func throttle(_ f: @escaping () -> Void) {
        work?.cancel()
        work = DispatchWorkItem() { [weak self] in
            self?.lastRun = Date()
            f()
        }
        if let work = work {
            let deadline: DispatchTime = .now() + currentDelay
            queue.asyncAfter(deadline: deadline, execute: work)
        }
    }
}

/* Usage: */

let throttler = Throttler(0.3)

for _ in 0..<1000 {
    throttler.throttle {
        print("!") // printed avg: 5-8 times when tested
    }
}
