import Foundation

struct IngredientUnit {
    let identifier: String
    let name: String
    let createdDate: Date

    init(identifier: String, name: String, createdDate: Date) {
        self.identifier = identifier
        self.name = name
        self.createdDate = createdDate
    }
}
