import Foundation
import Firebase

class ActivityService {

    private static let db = Firestore.firestore()

    public static func create(_ activity: Activity, completion: @escaping (String?) -> ()) {
        // Converte a atividade em JSON
        let JSON = try! JSONEncoder().encode(activity)
        // Converte o JSON em dicionário
        let data = try! JSONSerialization.jsonObject(with: JSON, options: []) as! [String: Any]

        db.collection("activities").addDocument(data: data) { (error) in
            if error != nil {
                completion("Ocorreu um erro, por favor tente novamente")
            }
            completion(nil)
        }
    }

    public static func get(completion: @escaping ([Activity]) -> ()) {
        var activities: [Activity] = []

        let request = db.collection("activities") as Query

        request.getDocuments() { (snapshot, error) in
            if error != nil {
                completion([])
            } else {
                for document in snapshot!.documents {
                    // Converte o documento em JSON
                    let data = try! JSONSerialization.data(withJSONObject: document.data())
                    // Converte o JSON em uma atividade
                    let activity = try! JSONDecoder().decode(Activity.self, from: data)
                    // Atribui a referência da atividade
                    activity.ref = document.documentID

                    activities.append(activity)
                }
                completion(activities)
            }
        }
    }

    public static func subscribe(activity: Activity, user: User, completion: @escaping (Error?) -> ()) {
        let request = db.collection("activities").document(activity.ref!)

        // Adiciona o usuário como inscrito na atividade (0 é o status pendente)
        let data = ["subscribers.\(user.ref!)": 0]

        // Submete requisição
        request.updateData(data) { (error) in
            completion(error)
        }
    }

}
