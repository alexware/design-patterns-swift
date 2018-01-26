
import Foundation

// Usage:

// 1. Self-executing closure

class System {
    private lazy var module: Module = {
        let module = Module(configuration: Component(), data: Component())
        // ...
        return module
    }()
    
    func launch(process: Process) {
        self.module.processSystem.launch(process: process)
    }
}

// 2. Using a factory method

class System2 {
    private lazy var module: Module = self.makeModule()
    
    func launch(process: Process) {
        self.module.processSystem.launch(process: process)
    }
    
    private func makeModule() -> Module {
        let module = Module(configuration: Component(), data: Component())
        // ...
        return module
    }
}

// abstract helper code:

protocol Process { }
struct Component { }
struct Subsystem { func launch(process: Process) {} }

class Module {
    let configuration: Component
    let data: Component
    var processSystem = Subsystem()
    init(configuration: Component, data: Component) {
        self.configuration = configuration
        self.data = data
    }
}
