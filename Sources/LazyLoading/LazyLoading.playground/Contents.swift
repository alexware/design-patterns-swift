
import Foundation

// abstract helper code:

protocol Process { }
struct Component { }
struct Subsystem { func launch(process: Process) {} }
struct SystemProcess: Process { }

class Module {
    let configuration: Component
    let data: Component
    var processSystem = Subsystem()
    init(configuration: Component, data: Component) {
        self.configuration = configuration
        self.data = data
    }
}

// Usage:

// 1. Self-executing closure

class System {
    private lazy var module: Module = {
        let module = Module(configuration: Component(), data: Component())
        // ...
        return module
    }()
    
    func launch(process: Process) {
        
        // lazy loading triggered here:
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

let system = System()
// module is not loaded yet

let process  = SystemProcess()
system.launch(process: process)


