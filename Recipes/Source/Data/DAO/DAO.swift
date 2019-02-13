import Foundation

protocol DAO {

    // MARK: - Category

    func getCategories(success: @escaping Success<[Category]>, failure: @escaping Failure)

    func createCategories(categories: [Category], success: @escaping Success<Void>, failure: @escaping Failure)

    // MARK: - Ingredient unit

    func getIngredientUnits(success: @escaping Success<[IngredientUnit]>, failure: @escaping Failure)

    func createIngredientUnits(ingredientUnits: [IngredientUnit],
                               success: @escaping Success<Void>,
                               failure: @escaping Failure)
}
