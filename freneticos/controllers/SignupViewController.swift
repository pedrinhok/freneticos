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
    
    @IBAction func clickSignup(_ sender: StandardButton) {
        sender.inactive()
        let user = User()
        
        guard let phone = phone.text, phone != "" else {
            popup(title: "Ops", message: "O telefone deve ser preenchido")
            return
        }
        user.phone = phone
        
        guard let name = name.text, name != "" else {
            popup(title: "Ops", message: "O nome deve ser preenchido")
            return
        }
        user.name = name
        
        guard let email = email.text, email != "" else {
            popup(title: "Ops", message: "O email deve ser preenchido")
            return
        }
        user.email = email
        
        guard let password = password.text, password != "" else {
            popup(title: "Ops", message: "A senha deve ser preenchida")
            return
        }
        guard let confirmPassword = confirmPassword.text, confirmPassword == password else {
            popup(title: "Ops", message: "A senha não corresponde a confirmação")
            return
        }
        user.password = password
        
        UserService.create(user) { (error) in
            if let error = error {
                self.popup(title: "Ops", message: error)
            } else {
                self.performSegue(withIdentifier: "gotoHome", sender: nil)
            }
            sender.active()
        }
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
