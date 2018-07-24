import Foundation
import CoreData
import Firebase
import FirebaseAuth

class UserService {
    
    private static let db = Firestore.firestore()
    
    public static func getCurrent() -> User? {
        do {
            let request: NSFetchRequest<ManagedUser> = ManagedUser.fetchRequest()
            let response = try AppDelegate.persistentContainer.viewContext.fetch(request)
            return User.decodeManagedUser(response.first)
        } catch {
            return nil
        }
    }
    
    public static func create(_ user: User, completion: @escaping (String?) -> ()) {
        Auth.auth().createUser(withEmail: user.email!, password: user.password!) { (res, error) in
            if error != nil {
                completion("An error has occured")
                return
            }
            guard let auth = res?.user else {
                completion("An error has occured")
                return
            }
            let JSON = try! JSONEncoder().encode(user)
            let data = try! JSONSerialization.jsonObject(with: JSON, options: []) as! [String: Any]
            db.collection("users").document(auth.uid).setData(data) { (error) in
                if error != nil {
                    completion("An error has occured")
                    return
                }
                let managed = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
                managed.ref = auth.uid
                managed.phone = user.phone
                managed.name = user.name
                managed.email = user.email
                AppDelegate.saveContext()
                completion(nil)
            }
        }
    }
    
}
