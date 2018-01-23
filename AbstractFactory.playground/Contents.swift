
import Foundation

enum Level {
    case junior, middle, senior
}

protocol SoftwareEngineer {}

class JuniorSE: SoftwareEngineer {}
class MiddleSE: SoftwareEngineer {}
class SeniorSE: SoftwareEngineer {}

protocol QA {}

class JuniorQA: QA {}
class MiddleQA: QA {}
class SeniorQA: QA {}

/* Abstract Factory */
protocol Company {
    func resources(_ level: Level) -> Team
}

protocol Team {
    func softwareEngineer() -> SoftwareEngineer
    func qaEngineer() -> QA
}

final class Facebook: Company {
    private let juniors = Juniors()
    private let middles = Middles()
    private let seniors = Seniors()
    
    /* Factory Method */
    func resources(_ level: Level) -> Team {
        switch level {
        case .junior:
            return juniors
        case .middle:
            return middles
        case .senior:
            return seniors
        }
    }
}

final class Juniors: Team {
    func softwareEngineer() -> SoftwareEngineer {
        return JuniorSE()
    }
    
    func qaEngineer() -> QA {
        return JuniorQA()
    }
}

final class Middles: Team {
    func softwareEngineer() -> SoftwareEngineer {
        return MiddleSE()
    }
    
    func qaEngineer() -> QA {
        return MiddleQA()
    }
}

final class Seniors: Team {
    func softwareEngineer() -> SoftwareEngineer {
        return SeniorSE()
    }
    
    func qaEngineer() -> QA {
        return SeniorQA()
    }
}

/* Usage: */

let facebook: Company = Facebook()

let seniorQA = facebook.resources(.senior).qaEngineer()
let midSE = facebook.resources(.middle).softwareEngineer()

