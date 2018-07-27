import UIKit

class CurrencyTextField: StandardTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged() {
        guard let currency = text?.currency() else { return }
        text = currency
    }
    
}
