import UIKit
import MapKit

class SetLocationViewController: UIViewController {
    
    // MARK: - properties
    
    var locationManager = CLLocationManager()
    var match: Match!
    
    // MARK: - outlets
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var name: StandardTextField!
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        map.delegate = self
        name.delegate = self
        
        name.text = match.location
        
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - actions
    
    @IBAction func clickSubmit(_ sender: StandardButton) {}
    
    // MARK: - selectors
    
    @objc func keyboardObserver(notification: NSNotification) {
        let frame: CGRect = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == Notification.Name.UIKeyboardWillShow {
            view.frame.origin.y = -frame.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
}

extension SetLocationViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] as CLLocation
        
        let span = MKCoordinateSpanMake(0.008, 0.008)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {}
    
}

extension SetLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // drop keyboard on click return
        textField.resignFirstResponder()
        return true
    }
    
}
