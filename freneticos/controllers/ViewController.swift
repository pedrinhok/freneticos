import UIKit

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserService.getCurrent() == nil {
            performSegue(withIdentifier: "gotoSignin", sender: nil)
        }
    }
    
}
