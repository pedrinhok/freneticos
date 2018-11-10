import Foundation

class Match: Codable {
    
    var ref: String?
    var refCreator: String?
    var name: String?
    var desc: String?
    var sport: String?
    var location: String?
    var x: Double?
    var y: Double?
    var moment: String?
    var duration: Int?
    var positions: Int?
    var price: Double?
    var subscribers: [Subscriber]?
    
    func durationString() -> String? {
        guard let duration = duration else { return nil }
        let m = (duration / 60) % 60
        let h = (duration / 3600)
        return ("\(h)h e \(m)min")
    }
    
}
