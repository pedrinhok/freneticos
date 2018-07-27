import UIKit

class SetScheduleViewController: UIViewController {
    
    // MARK: - properties
    
    var match: Match!
    
    // MARK: - outlets
    
    @IBOutlet weak var date: StandardTextField!
    @IBOutlet weak var time: StandardTextField!
    @IBOutlet weak var duration: StandardTextField!
    @IBOutlet var dateKeyboard: UIView!
    @IBOutlet weak var dateSelector: UIDatePicker!
    @IBOutlet var timeKeyboard: UIView!
    @IBOutlet weak var timeSelector: UIDatePicker!
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date.inputView = dateKeyboard
        time.inputView = timeKeyboard
        
        date.text = match.date
        time.text = match.time
        duration.text = match.duration
        
        dateSelector.minimumDate = Date()
    }
    
    // MARK: - actions
    
    @IBAction func clickSubmit(_ sender: StandardButton) {}
    
    @IBAction func dateSubmit(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        date.text = formatter.string(from: dateSelector.date)
        date.resignFirstResponder()
    }
    
    @IBAction func timeSubmit(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        time.text = formatter.string(from: timeSelector.date)
        time.resignFirstResponder()
    }
    
}
