import CloudKit

private let creationDateKey = "creationDate"

class QueryBuilder {
    private var query: CKQuery

    init(recordType: String) {
        let predicate = NSPredicate(value: true)
        query = CKQuery(recordType: recordType, predicate: predicate)
    }

    func addSortDescriptor(ascending: Bool = true) -> QueryBuilder {
        let createdAtSortDescriptor = NSSortDescriptor(key: creationDateKey, ascending: ascending)
        query.sortDescriptors = [createdAtSortDescriptor]
        return self
    }

    func addPredicate(format: String, argument: CVarArg) -> QueryBuilder {
        let predicate = NSPredicate(format: format, argument)
        let sortDescriptors = query.sortDescriptors
        query = CKQuery(recordType: query.recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        return self
    }

    func build() -> CKQuery {
        return query
    }
}
