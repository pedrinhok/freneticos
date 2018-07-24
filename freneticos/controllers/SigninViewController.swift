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
    
    // MARK: - functions
    
    func popup(title: String = "", message: String = "") {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            popup.dismiss(animated: true)
        }
        popup.addAction(action)
        
        present(popup, animated: true)
    }
    
    // MARK: - action functions
    
    @IBAction func unwindSignin(segue: UIStoryboardSegue) {}
    
    @IBAction func clickSingin(_ sender: StandardButton) {
        sender.inactive()
        UserService.signin(email: email.text ?? "", password: password.text ?? "") { (error) in
            if error != nil {
                self.popup(title: "Ops", message: "Usuário não encontrado")
            } else {
                self.performSegue(withIdentifier: "gotoHome", sender: nil)
            }
            sender.active()
        }
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
