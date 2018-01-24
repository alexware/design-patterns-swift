
import UIKit

/* interfaces */

protocol State {
    func next(in context: Context)
}

protocol Context {
    func set(_ state: State)
    func next()
}

/* "context" class to present a single interface to the outside world */

final class Controller: Context {
    
    /* pointer to the current "state" in the "context" class */
    private var state: State = Off()
    
    init() {}
    
    func set(_ state: State) {
        self.state = state
    }
    
    /* change the state of the state machine, change the current "state" pointer */
    func next() {
        self.state.next(in: self)
    }
}

/* different "states" of the state machine as derived structs of the State protocol */

struct Off: State {
    func next(in context: Context) {
        context.set(Low())
        print("Low Light")
    }
}

struct Low: State {
    func next(in context: Context) {
        context.set(Medium())
        print("Medium Light")
    }
}

struct Medium: State {
    func next(in context: Context) {
        context.set(High())
        print("Max!")
    }
}

struct High: State {
    func next(in context: Context) {
        context.set(Off())
        print("Off")
    }
}

let controller = Controller()

for _ in 0...9 {
    controller.next()
    sleep(1)
}
