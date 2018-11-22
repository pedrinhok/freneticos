import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let v = imageView else { return }
        v.image = UIImage(named: "arrow-right")
        v.setImageColor(color: UIColor(hex: "#CCCCCC"))
        imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 30), bottom: 5, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: v.frame.width)
        contentHorizontalAlignment = .left
        setImage(v.image, for: .normal)
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
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        
        setTitleColor(UIColor(hex: "#000000"), for: state)
    }
    
}
