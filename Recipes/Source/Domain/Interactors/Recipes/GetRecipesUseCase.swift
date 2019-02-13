import Foundation

class GetRecipesUseCase {
    private let repository: RecipeRepository

    init(repository: RecipeRepository) {
        self.repository = repository
    }

    func getRecipes(categoryIdentifier: String,
                    cursor: Any?,
                    success: @escaping Success<Page<Recipe>>,
                    failure: @escaping Failure) {

        repository.getRecipes(categoryIdentifier: categoryIdentifier,
                              cursor: cursor,
                              success: success,
                              failure: failure)
    }
}
