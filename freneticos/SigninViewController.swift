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
    }
    
    // MARK: - action functions
    
    @IBAction func unwindSignin(segue: UIStoryboardSegue) {}
    
    @IBAction func clickSingin(_ sender: StandardButton) {
    }
    
    @IBAction func clickSingup(_ sender: StandardButton) {
        performSegue(withIdentifier: "gotoSignup", sender: nil)
    }
    
}

extension SigninViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // drop keyboard on click return
        textField.resignFirstResponder()
        return true
    }
    
}
