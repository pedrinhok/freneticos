import Foundation

class User: Codable {
    
    var ref: String?
    var phone: String?
    var name: String?
    var email: String?
    var password: String?
    var gender: String?
    var birthday: Date?
    var height: Double?
    
    public static func decodeManagedUser(_ managed: ManagedUser?) -> User? {
        guard let managed = managed else {
            return nil
        }
        let user = User()
        user.ref = managed.ref
        user.phone = managed.phone
        user.name = managed.name
        user.email = managed.email
        return user
    }
    
}
