import Foundation

struct RecipesError: Error {
    let message: String?

    init(message: String? = nil) {
        self.message = message
    }
}
