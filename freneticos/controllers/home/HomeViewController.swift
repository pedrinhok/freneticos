import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - action functions
    
    @IBAction func unwindHome(segue: UIStoryboardSegue) {}
    
    @IBAction func clickNewMatch(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gotoNewMatch", sender: nil)
    }
    
}
