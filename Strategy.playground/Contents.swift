
import UIKit

protocol Strategy {
    func execute(collection: [Int]) -> [Int]
}

/* Shuffle concrete strategies */
final class BasicShuffleStrategy: Strategy {
    func execute(collection: [Int]) -> [Int] {
        var temp = [Int]()
        var input = collection
        while !input.isEmpty {
            let index = random(input.count)
            let element = input.remove(at: index)
            temp.append(element)
        }
        return temp
    }
}

final class KnuthShuffleStrategy: Strategy {
    func execute(collection: [Int]) -> [Int] {
        var result = collection
        for i in stride(from: collection.count - 1, through: 1, by: -1) {
            let j = random(i + 1)
            if i != j {
                result.swapAt(i, j)
            }
        }
        return result
    }
}

/* helper */
func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

final class Shuffler {
    private var collection: [Int]
    
    init(collection: [Int]) {
        self.collection = collection
    }
    
    func shuffle(strategy: Strategy) -> [Int] {
        return strategy.execute(collection: collection)
    }
}

let numbers = [2, 5, 6, 30, 75, 2, 9, 45]
let shuffler = Shuffler(collection: numbers)

let basicShuffleStrategy = BasicShuffleStrategy()
let knuthShuffleStrategy = KnuthShuffleStrategy()

/* switching algorithms */
let shuffled1 = shuffler.shuffle(strategy: basicShuffleStrategy)
let shuffled2 = shuffler.shuffle(strategy: knuthShuffleStrategy)
