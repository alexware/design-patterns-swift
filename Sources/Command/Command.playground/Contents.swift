
import UIKit

enum EngineerLevel: Int {
    case junior = 0, middle, senior
}

extension EngineerLevel: Comparable {
    static func < (lhs: EngineerLevel, rhs: EngineerLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func == (lhs: EngineerLevel, rhs: EngineerLevel) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

protocol JiraItem {
    var code: String { get }
    var description: String { get }
    var levelOfCompetency: EngineerLevel { get }
    var completed: Bool { get }
    func close(_ comment: String)
}

final class Task: JiraItem {
    let code: String
    let description: String
    let levelOfCompetency: EngineerLevel
    var completed: Bool {
        return _completed
    }
    
    private var _completed: Bool = false
    
    init(code: String, description: String, levelOfCompetency: EngineerLevel) {
        self.code = code
        self.description = description
        self.levelOfCompetency = levelOfCompetency
    }
    
    func close(_ message: String) {
        _completed = true
        print(message)
    }
}

final class SoftwareEngineer {
    let name: String
    let level: EngineerLevel
    var isDeveloping: Bool = false
    
    init(name: String, level: EngineerLevel) {
        self.name = name
        self.level = level
    }
    
    func resolve(_ task: JiraItem) -> Bool {
        guard !isDeveloping else {
            assert(false, "Something wrong here! Developer is working on another ticket.")
        }
        guard task.levelOfCompetency <= level else {
            assert(false, "Something wrong here! Developer is not qualified enough.")
        }
        isDeveloping = true
        print("\(name), iOS \(level) Developer has started \(task.code).")
        task.close("\(task.description) (\(task.code)) was merged into Dev branch.")
        return true
    }
}

final class EngineeringTeam {
    var level: EngineerLevel
    var engineers: [SoftwareEngineer]
    var higherCompetencyTeam: EngineeringTeam?
    
    init(engineers: [SoftwareEngineer], level: EngineerLevel, higherCompetencyTeam: EngineeringTeam?) {
        self.engineers = engineers
        self.level = level
        self.higherCompetencyTeam = higherCompetencyTeam
    }
    
    func tryToResolve(_ task: JiraItem) -> Bool {
        if task.levelOfCompetency > level || !hasAvailableSoftwareEngineers {
            if let team = higherCompetencyTeam {
                return team.tryToResolve(task)
            } else {
                print("No team member available.")
                return false
            }
        } else {
            if let availableSoftwareEngineer = availableSoftwareEngineer {
                return availableSoftwareEngineer.resolve(task)
            }
            assert(false, "Something went wrong!")
        }
    }
    
    private var availableSoftwareEngineer: SoftwareEngineer? {
        return engineers.filter({ $0.isDeveloping == false }).first
    }
    
    private var hasAvailableSoftwareEngineers: Bool {
        return engineers.filter({ $0.isDeveloping == false }).count > 0
    }
}

final class ITOutsorcingCompany {
    private var engineers: EngineeringTeam
    
    init(engineers: EngineeringTeam) {
        self.engineers = engineers
    }
    
    func resolve(_ task: JiraItem) -> Bool {
        return engineers.tryToResolve(task)
    }
}

/* Lets build the team: */

/* Here comes the cavalry */
let s1 = SoftwareEngineer(name: "Alex", level: .senior)
let s2 = SoftwareEngineer(name: "Volodya", level: .senior)
let s3 = SoftwareEngineer(name: "Petro", level: .senior)

let seniors = EngineeringTeam(engineers: [s1, s2, s3], level: .senior, higherCompetencyTeam: nil)

/* Ah, the work horses. Let's pop some tickets! */
let m1 = SoftwareEngineer(name: "Andrii", level: .middle)
let m2 = SoftwareEngineer(name: "Vitalii", level: .middle)
let m3 = SoftwareEngineer(name: "Dima", level: .middle)

let middles = EngineeringTeam(engineers: [m1, m2, m3], level: .middle, higherCompetencyTeam: seniors)

/* Juniors fresh from galera's 'Base Camp' to sink the ship...Ahoy! */
let j1 = SoftwareEngineer(name: "Kyrylo", level: .junior)
let j2 = SoftwareEngineer(name: "Mykyta", level: .junior)
let j3 = SoftwareEngineer(name: "Pavlo", level: .junior)

let juniors = EngineeringTeam(engineers: [j1, j2, j3], level: .junior, higherCompetencyTeam: middles)

/* Let's throw in some work for the guys: */
let backlog: [JiraItem] = [
    Task(code: "GAL-757", description: "Fix layout", levelOfCompetency: .junior),
    Task(code: "GAL-990", description: "Custom network protocol implementation", levelOfCompetency: .senior),
    Task(code: "GAL-932", description: "Fix database concurrency issue", levelOfCompetency: .senior),
    Task(code: "GAL-1003", description: "Develop complex UI component", levelOfCompetency: .middle),
    Task(code: "GAL-994", description: "Fix crash on tableView", levelOfCompetency: .junior),
    Task(code: "GAL-790", description: "Change button color", levelOfCompetency: .junior),
    Task(code: "GAL-852", description: "Fix UI component offsets", levelOfCompetency: .junior),
    Task(code: "GAL-1001", description: "Integrate Analitics", levelOfCompetency: .middle)
]

/* Work!  */
backlog.forEach {
    
    /* Will resolve task or find more competent mate and hand it over */
    juniors.tryToResolve(task)
}


