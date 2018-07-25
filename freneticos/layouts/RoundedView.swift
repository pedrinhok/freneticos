import UIKit

@IBDesignable
class RoundedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    var corner: CGFloat = 0 {
        didSet {
            layer.masksToBounds = true
            layer.cornerRadius = corner
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.masksToBounds = true
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            layer.masksToBounds = true
            layer.borderColor = borderColor?.cgColor
        }
    }
    
}
