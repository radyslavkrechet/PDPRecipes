import Foundation

class RecipesAccountRepository: AccountRepository {
    private let api: API

    init(api: API) {
        self.api = api
    }

    // MARK: - AccountRepository

    func getAccountStatus(success: @escaping Success<Void>, failure: @escaping Failure) {
        api.getAccountStatus(success: success, failure: failure)
    }
}
