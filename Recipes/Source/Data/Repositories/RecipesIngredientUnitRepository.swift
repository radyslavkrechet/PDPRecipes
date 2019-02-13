import Foundation

class RecipesIngredientUnitRepository: IngredientUnitRepository {
    private let api: API
    private let dao: DAO

    init(api: API, dao: DAO) {
        self.api = api
        self.dao = dao
    }

    // MARK: - IngredientUnitRepository

    func getIngredientUnits(success: @escaping Success<[IngredientUnit]>, failure: @escaping Failure) {
        dao.getIngredientUnits(success: { [weak self] ingredientUnits in
            guard ingredientUnits.isEmpty else {
                success(ingredientUnits)
                return
            }

            self?.getIngredientUnitsFromApi(success: success, failure: failure)
        }, failure: { error in
            failure(error)
        })
    }

    // MARK: - Private

    private func getIngredientUnitsFromApi(success: @escaping Success<[IngredientUnit]>, failure: @escaping Failure) {
        api.getIngredientUnits(success: { [weak self] ingredientUnits in
            self?.createIngredientUnitsInDao(ingredientUnits: ingredientUnits, success: success, failure: failure)
        }, failure: { error in
            failure(error)
        })
    }

    private func createIngredientUnitsInDao(ingredientUnits: [IngredientUnit],
                                            success: @escaping Success<[IngredientUnit]>,
                                            failure: @escaping Failure) {

        dao.createIngredientUnits(ingredientUnits: ingredientUnits, success: { _ in
            success(ingredientUnits)
        }, failure: { error in
            failure(error)
        })
    }
}
