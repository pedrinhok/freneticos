import UIKit

class StandardNavigationBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        barTintColor = UIColor(hex: "#FF5555")
        tintColor = UIColor(hex: "#FFFFFF")
        titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hex: "#FFFFFF")]
    }
    
}
