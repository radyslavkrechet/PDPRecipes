import CloudKit

private let nameKey = "name"

struct CloudKitIngredientUnitAdapter {
    static func adapt(_ record: CKRecord) -> IngredientUnit {
        let name = record[nameKey] as? String ?? String()
        let createdDate = record.creationDate ?? Date()
        return IngredientUnit(identifier: record.recordID.recordName, name: name, createdDate: createdDate)
    }
}
