
import UIKit

protocol Memento { }

protocol Originator {
    func save() -> Memento
    func load(save: Memento)
}

enum Weapon {
    case fists, sword, doubleSword, swordAndShield
}

struct GameState {
    var weapon: Weapon
    var health: CGFloat
    var mana: CGFloat
    var score: Int
}

struct GameSave: Memento {
    private let history: [Int: GameState]
    private let score: Int
    private let id: Int

    init(with checkPoint: CheckPoint) {
        print("\n<created a game save>")
        self.history = checkPoint.history
        self.score = checkPoint.score
        self.id = checkPoint.id
    }
    
    func apply(checkPoint: CheckPoint) {
        checkPoint.score = score
        checkPoint.history = history
        checkPoint.id = id
        print("\n<loaded previously saved game>")
    }
}

class CheckPoint: Originator {
    fileprivate var history = [Int: GameState]()
    fileprivate var score: Int = 0
    fileprivate var id: Int = 0
    
    func adjustStats(score: Int, weapon: Weapon, health: CGFloat, mana: CGFloat) {
        id += 1
        history[id] = GameState(weapon: weapon, health: health, mana: mana, score: score)
        self.score += score
        displayStats()
    }
    
    func save() -> Memento {
        return GameSave(with: self)
    }
    
    func load(save: Memento) {
        (save as? GameSave)?.apply(checkPoint: self)
        displayStats()
    }
    
    private func displayStats() {
        let sorted = history.sorted { (lhs, rhs) -> Bool in
            return lhs.key < rhs.key
        }
        if let last: GameState = sorted.last?.value {
            print("score: \(last.score), weapon: \(last.weapon), health: \(last.health), mana: \(last.mana)")
        }
    }
}

/* Usage */
let checkPoint = CheckPoint()
checkPoint.adjustStats(score: 0, weapon: .fists, health: 100, mana: 100)
checkPoint.adjustStats(score: 100, weapon: .sword, health: 80, mana: 100)

let save = GameSave(with: checkPoint)

checkPoint.adjustStats(score: 800, weapon: .doubleSword, health: 50, mana: 0)
checkPoint.adjustStats(score: 1080, weapon: .swordAndShield, health: 55, mana: 10)

checkPoint.save()

checkPoint.adjustStats(score: 960, weapon: .swordAndShield, health: 1, mana: 0)

checkPoint.load(save: save)

