import Foundation
import Firebase

class ActivityService {
    
    private static let db = Firestore.firestore()
    
    public static func create(_ match: Activity, completion: @escaping (String?) -> ()) {
        // Converte a atividade em JSON
        let JSON = try! JSONEncoder().encode(match)
        // Converte o JSON em dicionário
        let data = try! JSONSerialization.jsonObject(with: JSON, options: []) as! [String: Any]
        
        db.collection("matches").addDocument(data: data) { (error) in
            if error != nil {
                completion("Ocorreu um erro, por favor tente novamente")
            }
            completion(nil)
        }
    }
    
    public static func get(completion: @escaping ([Activity]) -> ()) {
        var matches: [Activity] = []
        
        let request = db.collection("matches") as Query
        
        request.getDocuments() { (snapshot, error) in
            if error != nil {
                completion([])
            } else {
                for document in snapshot!.documents {
                    // Converte o documento em JSON
                    let data = try! JSONSerialization.data(withJSONObject: document.data())
                    // Converte o JSON em uma atividade
                    let match = try! JSONDecoder().decode(Activity.self, from: data)
                    // Atribui a referência da atividade
                    match.ref = document.documentID
                    
                    matches.append(match)
                }
                completion(matches)
            }
        }
    }
    
    public static func subscribe(match: Activity, user: User, completion: @escaping (Error?) -> ()) {
        let request = db.collection("matches").document(match.ref!)
        
        // Adiciona o usuário como inscrito na atividade (0 é o status pendente)
        let data = ["subscribers.\(user.ref!)": 0]
        
        // Submete requisição
        request.updateData(data) { (error) in
            completion(error)
        }
    }
    
}
