import UIKit
import MapKit

class ShowMatchViewController: UIViewController {
    
    // MARK: - properties
    
    var match: Match!
    var geocoder = CLGeocoder()
    
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
    
    func setPlacemark() {
        let location = CLLocation(latitude: match.x!, longitude: match.y!)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            
            self.placemark.text = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
        }
    }
    
}
