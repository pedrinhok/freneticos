import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    // MARK: - properties
    
    var locationManager = CLLocationManager()
    
    // MARK: - outlets
    
    @IBOutlet weak var map: MKMapView!
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        map.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMatches()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "gotoShowMatch":
            guard let vc = segue.destination as? ShowActivityViewController else { return }
            guard let match = sender as? Activity else { return }
            vc.match = match
            return
            
        case .none, .some(_):
            return
        }
    }
    
    // MARK: - functions
    
    func getMatches() {
        MatchService.get { (matches) in
            var annotations: [Annotation] = []
            for match in matches {
                guard let x = match.x, let y = match.y else { continue }
                let annotation = Annotation(match, x: CLLocationDegrees(x), y: CLLocationDegrees(y))
                annotations.append(annotation)
            }
            self.map.addAnnotations(annotations)
        }
    }
    
    // MARK: - actions
    
    @IBAction func unwindHome(segue: UIStoryboardSegue) {}
    
    @IBAction func gotoNewMatch(_ sender: UIBarButtonItem) {
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Annotation else { return }
        let match = annotation.match
        performSegue(withIdentifier: "gotoShowMatch", sender: match)
    }
    
}

class Annotation: NSObject, MKAnnotation {
    
    var match: Activity
    var coordinate: CLLocationCoordinate2D
    
    init(_ data: Activity, x: CLLocationDegrees, y: CLLocationDegrees) {
        match = data
        coordinate = CLLocationCoordinate2D(latitude: x, longitude: y)
    }
    
}
