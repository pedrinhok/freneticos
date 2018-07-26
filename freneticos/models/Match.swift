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
    var date: String?
    var hour: String?
    var duration: String?
    var subscribers: [Subscriber]?
    
}
