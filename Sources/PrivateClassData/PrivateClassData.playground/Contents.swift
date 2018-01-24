
import UIKit

final class CircleData {
    var radius: Double {
        return _radius
    }
    
    var color: UIColor {
        return _color
    }
    
    var origin: CGPoint {
        return _origin
    }
    
    private let _radius: Double
    private let _color: UIColor
    private let _origin: CGPoint
    
    init(origin: CGPoint, radius: Double, color: UIColor) {
        self._color = color
        self._origin = origin
        self._radius = radius
    }
}

class Circle {
    /* Private class data used to reduce the visibility of the attributes and thus reduce the coupling */
    private let circleData: CircleData
    
    var circumference: Double {
        return circleData.radius * Double.pi
    }
    
    var diameter: Double {
        return circleData.radius * 2.0
    }
    
    init(origin: CGPoint, radius: Double, color: UIColor) {
        self.circleData = CircleData(origin: origin, radius: radius, color: color)
    }

    func draw() {
        // draw circle
    }
}
