import Foundation

protocol RecipeRepository {
    func getRecipes(categoryIdentifier: String,
                    cursor: Any?,
                    success: @escaping Success<Page<Recipe>>,
                    failure: @escaping Failure)

    func getRecipe(identifier: String, success: @escaping Success<Recipe>, failure: @escaping Failure)

    func createRecipe(recipe: Recipe, success: @escaping Success<Void>, failure: @escaping Failure)

    func deleteRecipe(identifier: String, success: @escaping Success<Void>, failure: @escaping Failure)
}
