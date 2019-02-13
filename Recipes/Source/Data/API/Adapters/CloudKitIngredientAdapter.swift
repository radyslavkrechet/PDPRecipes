import CloudKit

private let nameKey = "name"
private let numberKey = "number"
private let unitKey = "unit"

struct CloudKitIngredientAdapter {
    static func adapt(_ record: CKRecord, _ ingredientUnits: [IngredientUnit]) -> Ingredient {
        let name = record[nameKey] as? String ?? String()
        let number = record[numberKey] as? Int ?? 0
        let unitIdentifier = record[unitKey] as? String ?? String()
        let createdDate = record.creationDate ?? Date()

        var unit = IngredientUnit(identifier: unitIdentifier, name: name, createdDate: createdDate)
        if let ingredientUnit = ingredientUnits.first(where: { $0.identifier == unitIdentifier }) {
            unit = ingredientUnit
        }

        return Ingredient(identifier: record.recordID.recordName,
                          name: name,
                          number: number,
                          unit: unit,
                          createdDate: createdDate)
    }
}
