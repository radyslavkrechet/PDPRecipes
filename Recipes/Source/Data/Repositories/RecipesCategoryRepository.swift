import Foundation

class RecipesCategoryRepository: CategoryRepository {
    private let api: API
    private let dao: DAO

    init(api: API, dao: DAO) {
        self.api = api
        self.dao = dao
    }

    // MARK: - CategoryRepository

    func getCategories(success: @escaping Success<[Category]>, failure: @escaping Failure) {
        dao.getCategories(success: { [weak self] categories in
            guard categories.isEmpty else {
                success(categories)
                return
            }

            self?.getCategoriesFromApi(success: success, failure: failure)
        }, failure: { error in
            failure(error)
        })
    }

    // MARK: - Private

    private func getCategoriesFromApi(success: @escaping Success<[Category]>, failure: @escaping Failure) {
        api.getCategories(success: { [weak self] categories in
            self?.createCategoriesInDao(categories: categories, success: success, failure: failure)
        }, failure: { error in
            failure(error)
        })
    }

    private func createCategoriesInDao(categories: [Category],
                                       success: @escaping Success<[Category]>,
                                       failure: @escaping Failure) {

        dao.createCategories(categories: categories, success: { _ in
            success(categories)
        }, failure: { error in
            failure(error)
        })
    }
}
