import Foundation
import Firebase

class MatchService {
    
    private static let db = Firestore.firestore()
    
    public static func create(_ match: Match, completion: @escaping (String?) -> ()) {
        let JSON = try! JSONEncoder().encode(match)
        let data = try! JSONSerialization.jsonObject(with: JSON, options: []) as! [String: Any]
        db.collection("matches").addDocument(data: data) { (error) in
            if error != nil {
                completion("Ocorreu um erro, por favor tente novamente")
            }
            completion(nil)
        }
    }
    
}
