import UIKit

class CreateMatchViewController: UIViewController {
    
    // MARK: - properties
    
    var match: Activity = Activity()
    var sports: [String] = ["Artes marciais", "Atletismo", "Automobilismo", "Basquetebol", "Boliche", "Canoagem", "Ciclismo", "Corrida", "Fisiculturismo", "Futebol", "Futebol americano", "Ginástica", "Golfe", "Handebol", "Hipismo", "Natação", "Padel", "Pólo aquático", "Surfe", "Tênis", "Voleibol"]
    
    // MARK: - outlets
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var sport: StandardTextField!
    @IBOutlet weak var positions: StandardTextField!
    @IBOutlet weak var price: StandardTextField!
    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var desc: StandardTextField!
    @IBOutlet weak var buttonLocation: CustomButton!
    @IBOutlet weak var buttonSchedule: CustomButton!
    @IBOutlet var sportKeyboard: UIView!
    @IBOutlet weak var sportSelector: UIPickerView!
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sport.delegate = self
        positions.delegate = self
        price.delegate = self
        name.delegate = self
        desc.delegate = self
        
        sport.inputView = sportKeyboard
        sportSelector.dataSource = self
        sportSelector.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserver), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let location = match.location {
            buttonLocation.setTitle(location, for: .normal)
        }
        if let moment = match.datetime {
            buttonSchedule.setTitle("\(moment)", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "gotoSetLocation":
            guard let vc = segue.destination as? SetLocationViewController else { return }
            vc.match = match
            return
            
        case "gotoSetSchedule":
            guard let vc = segue.destination as? SetScheduleViewController else { return }
            vc.match = match
            return
            
        case .none, .some(_):
            return
        }
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
    
    // MARK: - actions
    
    @IBAction func unwindCreateMatch(segue: UIStoryboardSegue) {}
    
    @IBAction func gotoSetLocation(_ sender: CustomButton) {
        performSegue(withIdentifier: "gotoSetLocation", sender: nil)
    }
    
    @IBAction func gotoSetSchedule(_ sender: CustomButton) {
        performSegue(withIdentifier: "gotoSetSchedule", sender: nil)
    }
    
    @IBAction func onClickSubmit(_ sender: StandardButton) {
        sender.inactive()
        
        guard let sport = sport.text, sport != "" else {
            sender.active()
            return popup(title: "Ops", message: "Selecione o esporte")
        }
        if match.location == nil, match.x == nil, match.y == nil  {
            sender.active()
            return popup(title: "Ops", message: "Informe o local")
        }
        if match.datetime == nil, match.duration == nil  {
            sender.active()
            return popup(title: "Ops", message: "Informe a data e o horário")
        }
        guard let positions = positions.text, positions != "" else {
            sender.active()
            return popup(title: "Ops", message: "Informe o número de vagas")
        }
        guard let price = price.text, price != "" else {
            sender.active()
            return popup(title: "Ops", message: "Informe o preço para cada participante")
        }
        guard let name = name.text, name != "" else {
            sender.active()
            return popup(title: "Ops", message: "Informe um nome para a partida")
        }
        
        match.sport = sport
        match.positions = Int(positions)
        match.expense = price
        match.name = name
        match.desc = desc.text
        
        MatchService.create(match) { (error) in
            if error != nil {
                self.popup(title: "Ops", message: "Ocorreu um erro, tente novamente")
            } else {
                self.popup(title: "Sucesso", message: "Partida organizada com sucesso") {
                    self.performSegue(withIdentifier: "unwindHome", sender: nil)
                }
            }
            sender.active()
        }
        
    }
    
    @IBAction func onSelectSport(_ sender: UIButton) {
        let row = sportSelector.selectedRow(inComponent: 0)
        sport.text = sports[row]
        sport.resignFirstResponder()
    }
    
    // MARK: - selectors
    
    @objc func keyboardObserver(notification: NSNotification) {
        let frame: CGRect = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        var content: UIEdgeInsets = scroll.contentInset
        switch notification.name {
        case Notification.Name.UIKeyboardWillShow, Notification.Name.UIKeyboardWillChangeFrame:
            content.bottom = frame.size.height - 50
        default:
            content = UIEdgeInsets.zero
        }
        scroll.contentInset = content
    }
    
}

extension CreateMatchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // drop keyboard on click return
        textField.resignFirstResponder()
        return true
    }
    
}

extension CreateMatchViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sports.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sports[row]
    }
    
}
