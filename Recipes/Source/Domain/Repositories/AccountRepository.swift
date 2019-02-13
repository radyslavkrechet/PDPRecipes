import Foundation

protocol AccountRepository {
    func getAccountStatus(success: @escaping Success<Void>, failure: @escaping Failure)
}
