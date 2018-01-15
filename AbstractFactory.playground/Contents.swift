
import Foundation

enum Architecture {
    case enginola
    case ember
}

protocol CPU {}

class EmberCPU: CPU {}
class EnginolaCPU: CPU {}

protocol MMU {}

class EmberMMU: MMU {}
class EnginolaMMU: MMU {}

protocol AbstractFactory {
    func getFactory(_ arch: Architecture) -> ToolKitFactory
}

protocol ToolKitFactory {
    func createCPU() -> CPU
    func createMMU() -> MMU
}

final class HardwareFactory: AbstractFactory {
    private let emberToolkit = EmberToolkit()
    private let enginolaToolkit = EnginolaToolkit()
    
    func getFactory(_ arch: Architecture) -> ToolKitFactory {
        switch arch {
        case .ember:
            return emberToolkit
        case .enginola:
            return enginolaToolkit
        }
    }
}

final class EmberToolkit: ToolKitFactory {
    func createCPU() -> CPU {
        return EmberCPU()
    }
    
    func createMMU() -> MMU {
        return EmberMMU()
    }
}

final class EnginolaToolkit: ToolKitFactory {
    func createCPU() -> CPU {
        return EnginolaCPU()
    }
    
    func createMMU() -> MMU {
        return  EnginolaMMU()
    }
}

/* Usage: */

let abstractFactory: AbstractFactory = HardwareFactory()

let emberCPU = abstractFactory.getFactory(.ember).createCPU()
let emberMMU = abstractFactory.getFactory(.ember).createMMU()

let enginolaCPU = abstractFactory.getFactory(.enginola).createCPU()
let enginolaMMU = abstractFactory.getFactory(.enginola).createMMU()

