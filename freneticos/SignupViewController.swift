import UIKit

class SignupViewController: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet weak var phone: StandardTextField!
    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var password: StandardTextField!
    @IBOutlet weak var confirmPassword: StandardTextField!
    
    // MARK: - cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phone.delegate = self
        name.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - action functions
    
    @IBAction func clickSignup(_ sender: StandardButton) {
    }
    
    @IBAction func clickSignin(_ sender: StandardButton) {
        performSegue(withIdentifier: "unwindSignin", sender: nil)
    }
    
    // MARK: - selectors
    
    @objc func keyboardObserver(notification: NSNotification) {
        guard let frame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        switch notification.name {
        case Notification.Name.UIKeyboardWillShow, Notification.Name.UIKeyboardWillChangeFrame:
            if view.frame.origin.y != 0 { return }
            view.frame.origin.y = -frame.height
        default:
            view.frame.origin.y = 0
        }
    }
    
}

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // drop keyboard on click return
        textField.resignFirstResponder()
        return true
    }
    
}
