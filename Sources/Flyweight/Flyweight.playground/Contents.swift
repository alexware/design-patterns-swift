
import Foundation

protocol Potion {
    func drink()
}

final class HealingPotion: Potion {
    func drink() {
        print("You feel healed.")
    }
}

final class HolyWaterPotion: Potion {
    func drink() {
        print("You feel blessed.")
    }
}

final class InvisibilityPotion: Potion {
    func drink() {
        print("You become invisible.")
    }
}

// Flyweight object is the factory for creating potions

enum PotionType {
    case healing, holyWater, invisibility
    static let all: [PotionType] = [.healing, .holyWater, .invisibility]
}

class PotionFactory {
    private var potions = [PotionType: Potion]()
    
    init() { }
    
    func create(type: PotionType) -> Potion {
        // Get already produced potion
        if let potion = potions[type] {
            return potion
        
        // Produce new and add to potions arsenal for reusability
        } else {
            var potion: Potion
            
            switch type {
            case .healing:
                let healingPotion = HealingPotion()
                potions[type] = healingPotion
                potion = healingPotion
                
            case .holyWater:
                let holyWaterPotion = HolyWaterPotion()
                potions[type] = holyWaterPotion
                potion = holyWaterPotion
                
            case .invisibility:
                let invisibilityPotion = InvisibilityPotion()
                potions[type] = invisibilityPotion
                potion = invisibilityPotion
            }
            return potion
        }
    }
}

/* Usage: */

let potionFactory = PotionFactory()

potionFactory.create(type: .invisibility).drink()
potionFactory.create(type: .healing).drink()
potionFactory.create(type: .invisibility).drink()
potionFactory.create(type: .holyWater).drink()
potionFactory.create(type: .holyWater).drink()
potionFactory.create(type: .healing).drink()
potionFactory.create(type: .healing).drink()
potionFactory.create(type: .invisibility).drink()
potionFactory.create(type: .healing).drink()

// potion class instantiation is used only 3 times for each type of potions
// in other cases we just used chached instances


