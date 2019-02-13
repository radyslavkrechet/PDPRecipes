import Foundation

class GetAccountStatusUseCase {
    private let repository: AccountRepository

    init(repository: AccountRepository) {
        self.repository = repository
    }

    func getAccountStatus(success: @escaping Success<Void>, failure: @escaping Failure) {
        repository.getAccountStatus(success: success, failure: failure)
    }
}
