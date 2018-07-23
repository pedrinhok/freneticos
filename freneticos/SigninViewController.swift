import UIKit

class SigninViewController: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var password: StandardTextField!
    
    // MARK: - cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - action functions
    
    @IBAction func unwindSignin(segue: UIStoryboardSegue) {}
    
    @IBAction func clickSingin(_ sender: StandardButton) {
    }
    
    @IBAction func clickSingup(_ sender: StandardButton) {
        performSegue(withIdentifier: "gotoSignup", sender: nil)
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

extension SigninViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // drop keyboard on click return
        textField.resignFirstResponder()
        return true
    }
    
}
