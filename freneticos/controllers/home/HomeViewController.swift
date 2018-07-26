import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    // MARK: - properties
    
    var locationManager = CLLocationManager()
    
    // MARK: - outlets
    
    @IBOutlet weak var map: MKMapView!
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        map.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - actions
    
    @IBAction func unwindHome(segue: UIStoryboardSegue) {}
    
    @IBAction func clickNewMatch(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gotoNewMatch", sender: nil)
    }
    
}

extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] as CLLocation
        
        let span = MKCoordinateSpanMake(0.008, 0.008)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {}
    
}
