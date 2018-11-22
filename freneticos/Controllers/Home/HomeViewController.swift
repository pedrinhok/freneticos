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

        getActivities()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {

        case "gotoShowActivity":
            guard let vc = segue.destination as? ShowActivityViewController else { return }
            guard let activity = sender as? Activity else { return }
            vc.activity = activity
            return

        case .none, .some(_):
            return
        }
    }

    // MARK: - functions

    func getActivities() {
        ActivityService.get { (activities) in
            var annotations: [Annotation] = []
            for activity in activities {
                guard let x = activity.x, let y = activity.y else { continue }
                let annotation = Annotation(activity, x: CLLocationDegrees(x), y: CLLocationDegrees(y))
                annotations.append(annotation)
            }
            self.map.addAnnotations(annotations)
        }
    }

    // MARK: - actions

    @IBAction func unwindHome(segue: UIStoryboardSegue) {}

    @IBAction func gotoNewActivity(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gotoNewActivity", sender: nil)
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
        let activity = annotation.activity
        performSegue(withIdentifier: "gotoShowActivity", sender: activity)
    }

}

class Annotation: NSObject, MKAnnotation {

    var activity: Activity
    var coordinate: CLLocationCoordinate2D

    init(_ data: Activity, x: CLLocationDegrees, y: CLLocationDegrees) {
        activity = data
        coordinate = CLLocationCoordinate2D(latitude: x, longitude: y)
    }

}
