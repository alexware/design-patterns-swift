
import Foundation

enum EngineeringLevel {
    case junior, middle, senior
}

protocol SoftwareEngineerCompetencyMatrix {}

class JuniorSEMatrix: SoftwareEngineerCompetencyMatrix {}
class MiddleSEMatrix: SoftwareEngineerCompetencyMatrix {}
class SeniorSEMatrix: SoftwareEngineerCompetencyMatrix {}

protocol QACompetencyMatrix {}

class JuniorQAMatrix: QACompetencyMatrix {}
class MiddleQAMatrix: QACompetencyMatrix {}
class SeniorQAMatrix: QACompetencyMatrix {}

protocol CompetencyMatrix {
    func softwareEngineerMatrix() -> SoftwareEngineerCompetencyMatrix
    func qaEngineerMatrix() -> QACompetencyMatrix
}

/* Abstract Factory */
protocol Company {
    func resources(_ level: EngineeringLevel) -> CompetencyMatrix
}

final class Facebook: Company {
    private let juniorMatrix = JuniorMatrix()
    private let middleMatrix = MiddleMatrix()
    private let seniorMatrix = SeniorMatrix()
    
    /* Factory Method */
    func resources(_ level: EngineeringLevel) -> CompetencyMatrix {
        switch level {
        case .junior:
            return juniorMatrix
        case .middle:
            return middleMatrix
        case .senior:
            return seniorMatrix
        }
    }
}

final class JuniorMatrix: CompetencyMatrix {
    func softwareEngineerMatrix() -> SoftwareEngineerCompetencyMatrix {
        return JuniorSEMatrix()
    }
    
    func qaEngineerMatrix() -> QACompetencyMatrix {
        return JuniorQAMatrix()
    }
}

final class MiddleMatrix: CompetencyMatrix {
    func softwareEngineerMatrix() -> SoftwareEngineerCompetencyMatrix {
        return MiddleSEMatrix()
    }
    
    func qaEngineerMatrix() -> QACompetencyMatrix {
        return MiddleQAMatrix()
    }
}

final class SeniorMatrix: CompetencyMatrix {
    func softwareEngineerMatrix() -> SoftwareEngineerCompetencyMatrix {
        return SeniorSEMatrix()
    }
    
    func qaEngineerMatrix() -> QACompetencyMatrix {
        return SeniorQAMatrix()
    }
}

/* Usage: */

let facebook: Company = Facebook()

/* info */
let seniorQA = facebook.resources(.senior).qaEngineerMatrix()
let midSE = facebook.resources(.middle).softwareEngineerMatrix()

