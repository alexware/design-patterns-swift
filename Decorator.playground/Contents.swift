
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
    let description: String
    let category: ProductCategory
    let price: Double
    
    init(name: String, description: String, category: ProductCategory, price: Double) {
        self.name = name
        self.description = description
        self.category = category
        self.price = price
    }
}

class ProductPriceDecorator: Product {
    private let baseProduct: Product

    init(_ baseProduct: Product) {
        self.baseProduct = baseProduct
        super.init(name: baseProduct.name, description: baseProduct.description, baseProduct.category: String, price: baseProduct.price)
    }
}

class ProductBlackFridayPriceDecorator: ProductPriceDecorator {
    override var price: Double {
        var price = wrappedBaseProduct.price
        
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
        return price;
    }
}

class ProductCyberMondayPriceDecorator: ProductPriceDecorator {
    override var price: Double {
        var price = wrappedBaseProduct.price
        
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
        return price;
    }
}


