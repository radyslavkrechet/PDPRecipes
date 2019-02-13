import Foundation

struct Ingredient {
    let identifier: String
    let name: String
    let number: Int
    let unit: IngredientUnit
    let createdDate: Date

    init(identifier: String, name: String, number: Int, unit: IngredientUnit, createdDate: Date) {
        self.identifier = identifier
        self.name = name
        self.number = number
        self.unit = unit
        self.createdDate = createdDate
    }
}
