import Foundation

protocol CategoryRepository {
    func getCategories(success: @escaping Success<[Category]>, failure: @escaping Failure)
}
