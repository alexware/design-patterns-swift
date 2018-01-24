
import Foundation

final class Storage {
    static let shared = Storage()
    
    var info = (user: "Oleh", id: "1")
    
    /* Prevents from using the default initializer for class */
    private init() { }
}

/* Usage */

let name = Storage.shared.info.user    // "Oleh"
let id = Storage.shared.info.id        // "1"

Storage.shared.info.user = "Bobby"
Storage.shared.info.id = "2"

let updName = Storage.shared.info.user // "Bobby"
let updId = Storage.shared.info.id     // "2"
