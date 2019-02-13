import Foundation

struct Recipe {
    let identifier: String
    let name: String
    let note: String
    let photo: URL?
    let ingredients: [Ingredient]
    let steps: [String]
    let categoryIdentifier: String
    let createdDate: Date

    init(identifier: String,
         name: String,
         note: String,
         photo: URL?,
         ingredients: [Ingredient],
         steps: [String],
         categoryIdentifier: String,
         createdDate: Date) {

        self.identifier = identifier
        self.name = name
        self.note = note
        self.photo = photo
        self.ingredients = ingredients
        self.steps = steps
        self.categoryIdentifier = categoryIdentifier
        self.createdDate = createdDate
    }
}
