import Foundation

class DeleteRecipeUseCase {
    private let repository: RecipeRepository

    init(repository: RecipeRepository) {
        self.repository = repository
    }

    func deleteRecipe(identifier: String, success: @escaping Success<Void>, failure: @escaping Failure) {
        repository.deleteRecipe(identifier: identifier, success: success, failure: failure)
    }
}
