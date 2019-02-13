import Foundation

class RecipesRecipeRepository: RecipeRepository {
    private let api: API
    private let dao: DAO

    init(api: API, dao: DAO) {
        self.api = api
        self.dao = dao
    }

    // MARK: - RecipeRepository

    func getRecipes(categoryIdentifier: String,
                    cursor: Any?,
                    success: @escaping Success<Page<Recipe>>,
                    failure: @escaping Failure) {

        api.getRecipes(categoryIdentifier: categoryIdentifier, cursor: cursor, success: success, failure: failure)
    }

    func getRecipe(identifier: String, success: @escaping Success<Recipe>, failure: @escaping Failure) {
        dao.getIngredientUnits(success: { [weak self] ingredientUnits in
            self?.api.getRecipe(identifier: identifier,
                                ingredientUnits: ingredientUnits,
                                success: success,
                                failure: failure)
        }, failure: failure)
    }

    func createRecipe(recipe: Recipe, success: @escaping Success<Void>, failure: @escaping Failure) {
        api.createRecipe(recipe: recipe, success: success, failure: failure)
    }

    func deleteRecipe(identifier: String, success: @escaping Success<Void>, failure: @escaping Failure) {
        api.deleteRecipe(identifier: identifier, success: success, failure: failure)
    }
}
