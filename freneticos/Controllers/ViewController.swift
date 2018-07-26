import UIKit

class ViewController: UIViewController {
    
    // MARK: - override
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserService.getCurrent() != nil {
            performSegue(withIdentifier: "gotoHome", sender: nil)
        } else {
            performSegue(withIdentifier: "gotoSignin", sender: nil)
        }
    }
    
}
