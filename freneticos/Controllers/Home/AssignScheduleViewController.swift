import UIKit

class AssignScheduleViewController: UIViewController {

    // MARK: - properties

    let formatter = DateFormatter()
    var activity: Activity!
    var duration: Int?

    // MARK: - outlets

    @IBOutlet weak var datetime: StandardTextField!
    @IBOutlet weak var durationString: StandardTextField!
    @IBOutlet var datetimeKeyboard: UIView!
    @IBOutlet weak var datetimeSelector: UIDatePicker!
    @IBOutlet var durationKeyboard: UIView!
    @IBOutlet weak var durationSelector: UIDatePicker!

    // MARK: - override

    override func viewDidLoad() {
        super.viewDidLoad()

        datetime.text = activity.datetime
        durationString.text = activity.durationString()
        duration = activity.duration

        prepareKeyboards()
    }

    // MARK: - functions

    func prepareKeyboards() {
        datetime.inputView = datetimeKeyboard
        durationString.inputView = durationKeyboard

        datetimeSelector.minimumDate = Date()

        if let datetime = activity.datetime {
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            datetimeSelector.date = formatter.date(from: datetime)!
        }
        if let duration = duration {
            durationSelector.countDownDuration = TimeInterval(duration)
        } else {
            durationSelector.countDownDuration = 3600
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

        guard let datetime = datetime.text, datetime != "" else {
            return popup(title: "Ops", message: "Informe a data e o horário")
        }
        guard let duration = duration else {
            return popup(title: "Ops", message: "Informe a duração")
        }

        activity.datetime = datetime
        activity.duration = duration

        performSegue(withIdentifier: "unwindCreateActivity", sender: nil)
    }

    @IBAction func onSelectMoment(_ sender: UIButton) {
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        datetime.text = formatter.string(from: datetimeSelector.date)
        datetime.resignFirstResponder()
    }

    @IBAction func onSelectDuration(_ sender: UIButton) {
        duration = Int(durationSelector.countDownDuration)
        let m = (duration! / 60) % 60
        let h = (duration! / 3600)
        durationString.text = ("\(h)h e \(m)min")
        durationString.resignFirstResponder()
    }

}
