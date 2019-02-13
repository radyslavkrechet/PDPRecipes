import Foundation

class GetCategoriesUseCase {
    private let repository: CategoryRepository

    init(repository: CategoryRepository) {
        self.repository = repository
    }

    func getCategories(success: @escaping Success<[Category]>, failure: @escaping Failure) {
        repository.getCategories(success: success, failure: failure)
    }
}
