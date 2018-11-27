import UIKit

class SetScheduleViewController: UIViewController {
    
    // MARK: - properties
    
    let formatter = DateFormatter()
    var match: Match!
    var duration: Int?
    
    // MARK: - outlets
    
    @IBOutlet weak var moment: StandardTextField!
    @IBOutlet weak var durationString: StandardTextField!
    @IBOutlet var momentKeyboard: UIView!
    @IBOutlet weak var momentSelector: UIDatePicker!
    @IBOutlet var durationKeyboard: UIView!
    @IBOutlet weak var durationSelector: UIDatePicker!
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moment.text = match.moment
        durationString.text = match.durationString()
        duration = match.duration
        
        prepareKeyboards()
    }
    
    // MARK: - functions
    
    func prepareKeyboards() {
        moment.inputView = momentKeyboard
        durationString.inputView = durationKeyboard
        
        momentSelector.minimumDate = Date()
        
        if let moment = match.moment {
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            momentSelector.date = formatter.date(from: moment)!
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
        
        guard let moment = moment.text, moment != "" else {
            return popup(title: "Ops", message: "Inform the date and the time")
        }
        guard let duration = duration else {
            return popup(title: "Ops", message: "Inform the duration")
        }
        
        match.moment = moment
        match.duration = duration
        
        performSegue(withIdentifier: "unwindCreateMatch", sender: nil)
    }
    
    @IBAction func onSelectMoment(_ sender: UIButton) {
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        moment.text = formatter.string(from: momentSelector.date)
        moment.resignFirstResponder()
    }
    
    @IBAction func onSelectDuration(_ sender: UIButton) {
        duration = Int(durationSelector.countDownDuration)
        let m = (duration! / 60) % 60
        let h = (duration! / 3600)
        durationString.text = ("\(h)h e \(m)min")
        durationString.resignFirstResponder()
    }
    
}
