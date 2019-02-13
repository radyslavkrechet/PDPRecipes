import Foundation

class GetIngredientUnitsUseCase {
    private let repository: IngredientUnitRepository

    init(repository: IngredientUnitRepository) {
        self.repository = repository
    }

    func getIngredientUnits(success: @escaping Success<[IngredientUnit]>, failure: @escaping Failure) {
        repository.getIngredientUnits(success: success, failure: failure)
    }
}
