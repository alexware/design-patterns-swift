
import UIKit

enum InAppProduct {
    case tutorialOne, tutorialTwo, tutorialThree, tutorialFour, tutorialFive, additionalContents
    static let all: [InAppProduct] = [.tutorialOne, .tutorialTwo, .tutorialThree, .tutorialFour, .tutorialFive, .additionalContents]
}

extension InAppProduct: CustomStringConvertible {
    var description: String {
        var itemDescription = String()
        switch self {
        case .tutorialOne:
            itemDescription = "Free tutorial."
        case .tutorialTwo:
            itemDescription = "Tutorial 2: Beginner."
        case .tutorialThree:
            itemDescription = "Tutorial 3: Advanced."
        case .tutorialFour:
            itemDescription = "Tutorial 3: More Depth."
        case .tutorialFive:
            itemDescription = "Tutorial 4: Pro."
        case .additionalContents:
            itemDescription = "Exclusive additional contents."
        }
        return itemDescription
    }
}

struct User {
    let name: String
    let id: String
}

struct Storage {
    static var purchased: [String: Bool] {
        return [ "000000000": false, "000000001": false, "000000002": true, "000000003": true ]
    }
    private init() {}
}

protocol PurchaseServiceProtocol {
    func displayContents()
}

final class RealPurchaseService: PurchaseServiceProtocol {
    func displayContents() {
        InAppProduct.all.forEach {
            print($0.description)
        }
        print("\n")
    }
}

final class ProxyPurchaseService: PurchaseServiceProtocol {
    private let realPurchaseService: RealPurchaseService
    private var userAuthID: String
    
    init(userAuthID: String) {
        self.userAuthID = userAuthID
        self.realPurchaseService = RealPurchaseService()
    }
    
    func authorize(userAuthID: String) {
        self.userAuthID = userAuthID
    }
    
    func displayContents() {
        let purchased = Storage.purchased[userAuthID]
        if purchased == true {
            realPurchaseService.displayContents()
        } else {
            print(InAppProduct.tutorialOne.description + "\n")
        }
    }
}

let userWithSubscription = User(name: "Oleh", id: "000000003")
let freeUser = User(name: "Volodymyr", id: "000000001")

let protectedPurchaseService = ProxyPurchaseService(userAuthID: freeUser.id)
protectedPurchaseService.displayContents()

protectedPurchaseService.authorize(userAuthID: userWithSubscription.id)
protectedPurchaseService.displayContents()
