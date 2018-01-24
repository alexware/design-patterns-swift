
import Foundation

protocol TypeMachineDelegate: class {
    func typeMachineDidUpdateText(_ text: String)
}

final class TypeMachine {
    weak var delegate: TypeMachineDelegate?

    private var text = String()
    
    init() {}
    
    func pressChar(_ char: Character) {
        text += String(char)
        delegate?.typeMachineDidUpdateText(text)
    }
}

final class MachineTextReader {
    private var typeMachine: TypeMachine
    
    init(with typeMachine: TypeMachine) {
        self.typeMachine = typeMachine
        self.typeMachine.delegate = self
    }
}

extension MachineTextReader: TypeMachineDelegate {
    func typeMachineDidUpdateText(_ text: String) {
        print(text)
    }
}

/* Usage: */

/* TypeMachine delegates handling the text updates to the MachineTextReader */

let typeMachine = TypeMachine()
let reader = MachineTextReader(with: typeMachine)

let charactersToType: [Character] = ["H", "e", "l", "l", "o"]
charactersToType.forEach { typeMachine.pressChar($0); sleep(1) }

