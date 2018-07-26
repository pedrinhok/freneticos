import UIKit

class CreateMatchViewController: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var sport: StandardTextField!
    @IBOutlet weak var positions: StandardTextField!
    @IBOutlet weak var price: StandardTextField!
    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var desc: StandardTextField!
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sport.delegate = self
        positions.delegate = self
        price.delegate = self
        name.delegate = self
        desc.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - actions
    
    @IBAction func clickLocation(_ sender: CustomButton) {}
    
    @IBAction func clickSchedule(_ sender: CustomButton) {}
    
    @IBAction func clickSubmit(_ sender: StandardButton) {}
    
    // MARK: - selectors
    
    @objc func keyboardObserver(notification: NSNotification) {
        var frame: CGRect = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        frame = view.convert(frame, from: nil)
        var content: UIEdgeInsets = scroll.contentInset
        switch notification.name {
        case Notification.Name.UIKeyboardWillShow, Notification.Name.UIKeyboardWillChangeFrame:
            content.bottom = frame.size.height
        default:
            content = UIEdgeInsets.zero
        }
        scroll.contentInset = content
    }
    
}

extension CreateMatchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // drop keyboard on click return
        textField.resignFirstResponder()
        return true
    }
    
}
