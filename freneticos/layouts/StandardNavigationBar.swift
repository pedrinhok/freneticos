import UIKit

class StandardNavigationBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        barTintColor = UIColor(hexString: "#FF777A")
        tintColor = UIColor(hexString: "#FFFFFF")
        titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#FFFFFF")]
    }
    
}
