import UIKit
import MapKit

class ShowMatchViewController: UIViewController {
    
    // MARK: - properties
    
    let geocoder = CLGeocoder()
    let user = UserService.getCurrent()!
    var match: Match!
    
    // MARK: - outlets
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var sport: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var placemark: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var positions: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var status: UILabel!
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        desc.text = match.desc
        sport.text = match.sport
        location.text = match.location
        schedule.text = match.moment
        positions.text = "\(match.positions!)"
        price.text = match.price
        
        setPlacemark()
    }
    
    // MARK: - functions
    
    func popup(title: String = "", message: String = "", completion: (() -> ())? = nil) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            popup.dismiss(animated: true)
            guard let completion = completion else { return }
            completion()
        }
        popup.addAction(action)
        
        present(popup, animated: true)
    }
    
    func setPlacemark() {
        let location = CLLocation(latitude: match.x!, longitude: match.y!)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            
            self.placemark.text = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
        }
    }
    
    // MARK: - actions
    
    @IBAction func onClickSubmit(_ sender: StandardButton) {
        sender.inactive()
        
        let user = UserService.getCurrent()!
        
        MatchService.subscribe(match: match, user: user) { (error) in
            if error != nil {
                self.popup(title: "Ops", message: "An error has occurred")
            } else {
                self.popup(title: "Success", message: "You're subscribed to the activity!") {
                    self.performSegue(withIdentifier: "unwindHome", sender: nil)
                }
            }
            sender.active()
        }
    }
    
}
