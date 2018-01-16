
import UIKit

enum ProductCategory {
    case techMobile
    case techAccessories
    case techComputerAndOffice
    case techConsumerElectronics
    case techHomeImprovement
    case clothesWomen
    case clothesMen
    case clothesKids
    case toys
}

protocol ProductProtocol {
    var name: String { get }
    var description: String { get }
    var category: ProductCategory { get }
    var price: Double { get }
}

class Product: ProductProtocol {
    
    let name: String
    let category: ProductCategory
    
    var description: String {
        get { return _description }
    }
    
    var price: Double {
        get { return _price }
    }
    
    private let _description: String
    private let _price: Double
    
    init(name: String, description: String, category: ProductCategory, price: Double) {
        self.name = name
        self.category = category
        self._description = description
        self._price = price
    }
}

class ProductPriceDecorator: Product {
    let baseProduct: Product
    
    init(_ baseProduct: Product) {
        self.baseProduct = baseProduct
        super.init(name: baseProduct.name, description: baseProduct.description, category: baseProduct.category, price: baseProduct.price)
    }
}

class ProductBlackFridayDecorator: ProductPriceDecorator {
    override var description: String {
        return baseProduct.description + "This is Black Friday! Discount: \(baseProduct.price - price) $"
    }
    
    override var price: Double {
        var price = baseProduct.price

        switch category {

        case .techMobile:
            price = price * 0.95

        case .techAccessories:
            price = price * 0.65

        case .techComputerAndOffice, .techConsumerElectronics, .techHomeImprovement:
            price = price * 0.95

        case .clothesWomen:
            price = price * 0.60

        case .clothesMen:
            price = price * 0.90

        case .clothesKids:
            price = price * 0.60

        case .toys:
            price = price * 0.80
        }
        return price
    }
}

class ProductCyberMondayDecorator: ProductPriceDecorator {
    override var description: String {
        return baseProduct.description + "Discounts for ALL! Happy Cyber Monday!"
    }
    
    override var price: Double {
        var price = baseProduct.price

        switch category {

        case .techMobile:
            price = price * 0.80

        case .techAccessories:
            price = price * 0.50

        case .techComputerAndOffice, .techConsumerElectronics:
            price = price * 0.75

        case .techHomeImprovement:
            price = price * 0.85

        default:
            break
        }
        return price
    }
}

let iPhoneX = Product(name: "iPhoneX", description: "Has animated 'shit' emoji!", category: .techMobile, price: 1800)

let iPhoneXBlackFridayDecorator = ProductBlackFridayDecorator(iPhoneX)
let iPhoneXCyberMondayDecorator = ProductCyberMondayDecorator(iPhoneX)

let blPrice = iPhoneXBlackFridayDecorator.price
let blDescription = iPhoneXBlackFridayDecorator.description
let cmPrice = iPhoneXCyberMondayDecorator.price
let cmDescription = iPhoneXCyberMondayDecorator.description

