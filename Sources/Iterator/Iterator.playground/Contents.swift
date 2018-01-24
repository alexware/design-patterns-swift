
struct Instruction {
    let name: String
}

/* IteratorProtocol to the next element and returns it, or `nil` if no next element
 * exists.
 */

struct InstructionsIterator: IteratorProtocol {
    private let instructions: [Instruction]
    private var current = 0
    
    init(_ instructions: [Instruction]) {
        self.instructions = instructions
    }
    
    mutating func next() -> Instruction? {
        let next = instructions.count > current ? instructions[current] : nil
        current += 1
        return next
    }
}

/* Usage: */

struct InstructionsWrapper {
    let instructions: [Instruction]
}

extension InstructionsWrapper: Sequence {
    func makeIterator() -> InstructionsIterator {
        return InstructionsIterator(instructions)
    }
}

let instructionsWrapper = InstructionsWrapper(instructions: [
    Instruction(name: "Analizing"),
    Instruction(name: "Seeking Humans..."),
    Instruction(name: "Destroying!"),
    Instruction(name: "Laughing. Mua-ha-ha.")
])

func execute(instruction: Instruction) {
    print(instruction)
}

for instrution in instructionsWrapper {
    execute(instruction: instrution)
}
