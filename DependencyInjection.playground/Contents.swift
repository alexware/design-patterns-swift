
import UIKit

protocol DBConfiguration {
    var host: String { get }
    var port: Int    { get }
    var username: String { get }
    var password: String { get }
}

class DatabaseConfiguration: DBConfiguration {
    var host: String {
        return _host
    }
    
    var port: Int {
        return _port
    }
    
    var username: String {
        return _username
    }
    
    var password: String {
        return _password
    }
    
    private let _host: String
    private let _port: Int
    private let _username: String
    private let _password: String
    
    init(host: String, port: Int, username: String, password: String) {
        self._host = host
        self._port = port
        self._username = username
        self._password = password
    }
}

protocol DBConnection {
    var dsn: String { get }
}

class DatabaseConnection {
    var dsn: String {
        return "\(configuration.username):\(configuration.password):\(configuration.host):\(configuration.port)"
    }
    
    private let configuration: DBConfiguration
    
    init(configuration: DBConfiguration) {
        self.configuration = configuration
    }
}

let configuration = DatabaseConfiguration(host: "localhost", port: 1111, username: "oleg", password: "applejesus2018")
/* configuration is injected into DatabaseConnection class
 * without Dependency Injection, config would be created directly in DatabaseConnection
 * which is not good for testing and extension
 */
let connection = DatabaseConnection(configuration: configuration)
let dns = connection.dsn
