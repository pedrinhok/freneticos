import UIKit

class StandardTabBar: UITabBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        itemPositioning = .centered
        tintColor = UIColor(hexString: "#FF777A")
        
        guard let items = items else { return }
        
        var space: CGFloat = 0.0
        switch traitCollection.horizontalSizeClass {
        case .compact:
            space = 5.0
        case .regular:
            space = 0.0
        default:
            space = 0.0
        }
        
        for i in items {
            i.title = ""
            i.imageInsets = UIEdgeInsets(top: space, left: 0.0, bottom: -space, right: 0.0)
        }
    }
    
}
