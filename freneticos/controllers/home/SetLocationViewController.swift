import UIKit
import MapKit

class SetLocationViewController: UIViewController {
    
    // MARK: - properties
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var match: Match!
    
    // MARK: - outlets
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var name: StandardTextField!
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        
        name.text = match.location
        
        setCurrentLocation()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapObserver))
        map.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - functions
    
    func setCurrentLocation() {
        var coordinate: CLLocationCoordinate2D
        
        if let x = match.x, let y = match.y {
            coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(x), longitude: CLLocationDegrees(y))
            setAnnotation(coordinate: coordinate)
        } else {
            guard let location = locationManager.location else { return }
            coordinate = location.coordinate
        }
        
        let span = MKCoordinateSpanMake(0.008, 0.008)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        map.setRegion(region, animated: true)
    }
    
    func setAnnotation(coordinate: CLLocationCoordinate2D) {
        map.removeAnnotations(map.annotations)
        let ann = MKPointAnnotation()
        ann.coordinate = coordinate
        map.addAnnotation(ann)
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            print("\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")")
        }
    }
    
    // MARK: - actions
    
    @IBAction func clickSubmit(_ sender: StandardButton) {}
    
    // MARK: - selectors
    
    @objc func mapObserver(tap: UITapGestureRecognizer) {
        let position = tap.location(in: map)
        let coordinate = map.convert(position, toCoordinateFrom: map)
        
        match.x = coordinate.latitude
        match.y = coordinate.longitude
        
        setAnnotation(coordinate: coordinate)
    }
    
    @objc func keyboardObserver(notification: NSNotification) {
        let frame: CGRect = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == Notification.Name.UIKeyboardWillShow {
            view.frame.origin.y = -frame.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
}

extension SetLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] as CLLocation
        
        let span = MKCoordinateSpanMake(0.008, 0.008)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }
    
}

extension SetLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // drop keyboard on click return
        textField.resignFirstResponder()
        return true
    }
    
}
