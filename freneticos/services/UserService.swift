import Foundation
import CoreData
import FirebaseAuth

class UserService {
    
    public static func getCurrent() -> ManagedUser? {
        do {
            let request: NSFetchRequest<ManagedUser> = ManagedUser.fetchRequest()
            let response = try AppDelegate.persistentContainer.viewContext.fetch(request)
            return response.first
        } catch {
            return nil
        }
    }
    
    public static func create(_ data: User, completion: @escaping (String?) -> ()) {
        Auth.auth().createUser(withEmail: data.email!, password: data.password!) { (res, error) in
            if error != nil {
                completion("An error has occured")
                return
            }
            guard let auth = res?.user else {
                completion("An error has occured")
                return
            }
            let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
            user.ref = auth.uid
            user.phone = data.phone
            user.name = data.name
            user.email = data.email
            AppDelegate.saveContext()
            completion(nil)
        }
    }
    
}
