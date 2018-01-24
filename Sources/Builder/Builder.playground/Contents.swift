
import UIKit

protocol ComponentStyle {
    var backgroundColor: UIColor { get set }
    var borderColor: UIColor { get set }
    var borderWidth: CGFloat { get set }
    var size: CGSize { get set }
}

class TabStyle: ComponentStyle {
    var backgroundColor: UIColor = .white
    var borderColor: UIColor = .black
    var borderWidth: CGFloat = 2.0
    var size: CGSize = CGSize(width: 100.0, height: 54.0)
    
    init(build: (TabStyle) -> Void) { build(self) }
    
    private init() {}
}

/* Usage: */

let tabStyle = TabStyle(build: {
    $0.backgroundColor = .yellow
    $0.borderColor = .clear
    $0.borderWidth = 0.0
    $0.size = CGSize(width: 80, height: 40)
})
