import CloudKit

private let recipeRecordType = "Recipe"
private let ingredientRecordType = "Ingredient"
private let nameKey = "name"
private let noteKey = "note"
private let photoKey = "photo"
private let stepsKey = "steps"
private let categoryKey = "category"
private let numberKey = "number"
private let unitKey = "unit"
private let recipeKey = "recipe"

struct CloudKitRecipeAdapter {
    static func adapt(_ record: CKRecord,
                      _ ingredientRecords: [CKRecord] = [],
                      _ ingredientUnits: [IngredientUnit] = []) -> Recipe {

        let name = record[nameKey] as? String ?? String()
        let note = record[noteKey] as? String ?? String()
        let photo = (record[photoKey] as? CKAsset)?.fileURL
        let ingredients = ingredientRecords.map { CloudKitIngredientAdapter.adapt($0, ingredientUnits) }
        let steps = record[stepsKey] as? [String] ?? []
        let categoryIdentifier = record[categoryKey] as? String ?? String()
        let createdDate = record.creationDate ?? Date()

        return Recipe(identifier: record.recordID.recordName,
                      name: name,
                      note: note,
                      photo: photo,
                      ingredients: ingredients,
                      steps: steps,
                      categoryIdentifier: categoryIdentifier,
                      createdDate: createdDate)
    }

    static func adapt(_ recipe: Recipe) -> [CKRecord] {
        var records = [CKRecord]()

        let dishRecord = CKRecord(recordType: recipeRecordType)

        if let photo = recipe.photo {
            let photoAsset = CKAsset(fileURL: photo)
            dishRecord[photoKey] = photoAsset
        }

        dishRecord[nameKey] = recipe.name
        dishRecord[noteKey] = recipe.note
        dishRecord[stepsKey] = recipe.steps
        dishRecord[categoryKey] = recipe.categoryIdentifier
        records.append(dishRecord)

        recipe.ingredients.forEach {
            let ingredientRecord = CKRecord(recordType: ingredientRecordType)
            ingredientRecord[nameKey] = $0.name
            ingredientRecord[numberKey] = $0.number
            ingredientRecord[unitKey] = $0.unit.identifier
            ingredientRecord[recipeKey] = CKRecord.Reference(recordID: dishRecord.recordID, action: .deleteSelf)
            records.append(ingredientRecord)
        }

        return records
    }
}
