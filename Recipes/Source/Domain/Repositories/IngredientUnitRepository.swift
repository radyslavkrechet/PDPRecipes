import Foundation

protocol IngredientUnitRepository {
    func getIngredientUnits(success: @escaping Success<[IngredientUnit]>, failure: @escaping Failure)
}
