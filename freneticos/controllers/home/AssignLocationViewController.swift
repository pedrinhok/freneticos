import UIKit
import MapKit

class AssignLocationViewController: UIViewController {
    
    // MARK: - properties
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var match: Activity!
    var ann: MKPointAnnotation?
    
    // MARK: - outlets
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var placemark: UILabel!
    
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
        ann = MKPointAnnotation()
        ann!.coordinate = coordinate
        map.removeAnnotations(map.annotations)
        map.addAnnotation(ann!)
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            
            self.placemark.text = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
        }
    }
    
    func popup(title: String = "", message: String = "") {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            popup.dismiss(animated: true)
        }
        popup.addAction(action)
        
        present(popup, animated: true)
    }
    
    // MARK: - actions
    
    @IBAction func onClickSubmit(_ sender: StandardButton) {
        
        guard let ann = ann else {
            return popup(title: "Ops", message: "Clique no mapa para selecionar o local")
        }
        guard let name = name.text, name != "" else {
            return popup(title: "Ops", message: "Informe um nome para o local")
        }
        
        match.location = name
        match.x = ann.coordinate.latitude
        match.y = ann.coordinate.longitude
        
        performSegue(withIdentifier: "unwindCreateMatch", sender: nil)
    }
    
    // MARK: - selectors
    
    @objc func mapObserver(tap: UITapGestureRecognizer) {
        let position = tap.location(in: map)
        let coordinate = map.convert(position, toCoordinateFrom: map)
        
        setAnnotation(coordinate: coordinate)
    }
    
    @objc func keyboardObserver(notification: NSNotification) {
        let frame: CGRect = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == Notification.Name.UIKeyboardWillShow {
            view.frame.origin.y = -(frame.height - 50)
        } else {
            view.frame.origin.y = 0
        }
    }
    
}

extension AssignLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // drop keyboard on click return
        textField.resignFirstResponder()
        return true
    }
    
}
