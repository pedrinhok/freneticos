import Foundation

class Activity: Codable {
    
    var ref: String?
    var refCreator: String?
    var name: String?
    var desc: String?
    var sport: String?
    var location: String?
    var x: Double?
    var y: Double?
    var datetime: String?
    var duration: Int?
    var positions: Int?
    var expense: String?
    var subscribers: [String: Int]?
    
    func durationString() -> String? {
        guard let duration = duration else { return nil }
        let m = (duration / 60) % 60
        let h = (duration / 3600)
        return ("\(h)h e \(m)min")
    }
    
}
