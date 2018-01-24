
import UIKit

/* 1. Initializer Injection (DI through an initializer)  */

protocol Serializer {
    func serialize(_ data: Data)
}

class DataSerializer: Serializer {
    init() { }
    func serialize(_ data: Data) { }
}

final class DataManager {
    private let serializer: Serializer
    
    init(with serializer: Serializer) {
        self.serializer = serializer
    }
}

let serializer = DataSerializer()
let dataManager = DataManager(with: serializer)


/* 2. Method Injection (dependency injection in methods)  */

extension DataManager {
    func serialize(data: Data, with serializer: Serializer) {
        serializer.serialize(data)
    }
}


/* 3. Property Injection (DI using properties)  */

protocol HTTPClient { }

class NetworkClient: HTTPClient {}

final class StoreCoordinator {
    var httpClient: HTTPClient?
    
    init() { }
}

let httpClient = NetworkClient()
let storeCoordinator = StoreCoordinator()
storeCoordinator.httpClient = httpClient
