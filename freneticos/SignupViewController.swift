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
    }
    
    // MARK: - action functions
    
    @IBAction func clickSignup(_ sender: StandardButton) {
    }
    
    @IBAction func clickSignin(_ sender: StandardButton) {
        performSegue(withIdentifier: "unwindSignin", sender: nil)
    }
    
}

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // drop keyboard on click return
        textField.resignFirstResponder()
        return true
    }
    
}
