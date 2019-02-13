import Foundation

class GetRecipeUseCase {
    private let repository: RecipeRepository

    init(repository: RecipeRepository) {
        self.repository = repository
    }

    func getRecipe(identifier: String, success: @escaping Success<Recipe>, failure: @escaping Failure) {
        repository.getRecipe(identifier: identifier, success: success, failure: failure)
    }
}
