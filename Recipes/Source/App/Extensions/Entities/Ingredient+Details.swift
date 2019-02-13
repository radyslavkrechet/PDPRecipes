import Foundation

extension Ingredient {
    var details: String {
        return "\(number) \(unit.name.localized()) \(name)"
    }
}
