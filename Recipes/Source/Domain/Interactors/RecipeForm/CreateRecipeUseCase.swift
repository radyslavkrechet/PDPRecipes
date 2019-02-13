import Foundation

class CreateRecipeUseCase {
    private let repository: RecipeRepository

    init(repository: RecipeRepository) {
        self.repository = repository
    }

    func createRecipe(recipe: Recipe, success: @escaping Success<Void>, failure: @escaping Failure) {
        repository.createRecipe(recipe: recipe, success: success, failure: failure)
    }
}
