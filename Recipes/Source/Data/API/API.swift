import Foundation

protocol API {

    // MARK: - Account

    func getAccountStatus(success: @escaping Success<Void>, failure: @escaping Failure)

    // MARK: - Category

    func getCategories(success: @escaping Success<[Category]>, failure: @escaping Failure)

    // MARK: - Ingredient unit

    func getIngredientUnits(success: @escaping Success<[IngredientUnit]>, failure: @escaping Failure)

    // MARK: - Recipe

    func getRecipes(categoryIdentifier: String,
                    cursor: Any?,
                    success: @escaping Success<Page<Recipe>>,
                    failure: @escaping Failure)

    func getRecipe(identifier: String,
                   ingredientUnits: [IngredientUnit],
                   success: @escaping Success<Recipe>,
                   failure: @escaping Failure)

    func createRecipe(recipe: Recipe, success: @escaping Success<Void>, failure: @escaping Failure)

    func deleteRecipe(identifier: String, success: @escaping Success<Void>, failure: @escaping Failure)
}
