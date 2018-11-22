import UIKit
import MapKit

class ShowActivityViewController: UIViewController {

    // MARK: - properties

    let geocoder = CLGeocoder()
    let user = UserService.getCurrent()!
    var activity: Activity!

    // MARK: - outlets

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var sport: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var placemark: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var positions: UILabel!
    @IBOutlet weak var expense: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var status: UILabel!

    // MARK: - override

    override func viewDidLoad() {
        super.viewDidLoad()

        desc.text = activity.desc
        sport.text = activity.sport
        location.text = activity.location
        schedule.text = activity.datetime
        positions.text = "\(activity.positions!)"
        expense.text = activity.expense

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
        let location = CLLocation(latitude: activity.x!, longitude: activity.y!)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }

            self.placemark.text = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
        }
    }

    // MARK: - actions

    @IBAction func onClickSubmit(_ sender: StandardButton) {
        sender.inactive()

        let user = UserService.getCurrent()!

        ActivityService.subscribe(activity: activity, user: user) { (error) in
            if error != nil {
                self.popup(title: "Ops", message: "Ocorreu um erro, tente novamente")
            } else {
                self.popup(title: "Sucesso", message: "A sua inscrição foi realizada com sucesso!")
            }
            sender.active()
        }
    }

}
