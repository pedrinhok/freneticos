import UIKit

class SetScheduleViewController: UIViewController {
    
    // MARK: - properties
    
    let formatter = DateFormatter()
    var match: Match!
    var duration: Int?
    
    // MARK: - outlets
    
    @IBOutlet weak var date: StandardTextField!
    @IBOutlet weak var time: StandardTextField!
    @IBOutlet weak var durationString: StandardTextField!
    @IBOutlet var dateKeyboard: UIView!
    @IBOutlet weak var dateSelector: UIDatePicker!
    @IBOutlet var timeKeyboard: UIView!
    @IBOutlet weak var timeSelector: UIDatePicker!
    @IBOutlet var durationKeyboard: UIView!
    @IBOutlet weak var durationSelector: UIDatePicker!
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date.text = match.date
        time.text = match.time
        durationString.text = match.durationString()
        duration = match.duration
        
        prepareKeyboards()
    }
    
    // MARK: - functions
    
    func prepareKeyboards() {
        date.inputView = dateKeyboard
        time.inputView = timeKeyboard
        durationString.inputView = durationKeyboard
        
        dateSelector.minimumDate = Date()
        
        if let date = match.date {
            formatter.dateFormat = "dd/MM/yyyy"
            dateSelector.date = formatter.date(from: date)!
        }
        if let time = match.time {
            formatter.dateFormat = "HH:mm"
            timeSelector.date = formatter.date(from: time)!
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
        
        guard let date = date.text, date != "" else {
            return popup(title: "Ops", message: "Informe a data da partida")
        }
        guard let time = time.text, time != "" else {
            return popup(title: "Ops", message: "Informe o horário da partida")
        }
        guard let duration = duration else {
            return popup(title: "Ops", message: "Informe a duração da partida")
        }
        
        match.date = date
        match.time = time
        match.duration = duration
        
        performSegue(withIdentifier: "unwindCreateMatch", sender: nil)
    }
    
    @IBAction func onSelectDate(_ sender: UIButton) {
        formatter.dateFormat = "dd/MM/yyyy"
        date.text = formatter.string(from: dateSelector.date)
        date.resignFirstResponder()
    }
    
    @IBAction func onSelectTime(_ sender: UIButton) {
        formatter.dateFormat = "HH:mm"
        time.text = formatter.string(from: timeSelector.date)
        time.resignFirstResponder()
    }
    
    @IBAction func onSelectDuration(_ sender: UIButton) {
        duration = Int(durationSelector.countDownDuration)
        let m = (duration! / 60) % 60
        let h = (duration! / 3600)
        durationString.text = ("\(h)h e \(m)min")
        durationString.resignFirstResponder()
    }
    
}
