import Foundation

extension NSObject {
    class var nameOfClass: String {
        return String(describing: self)
    }
    var nameOfClass: String {
        return String(describing: type(of: self))
    }
}
