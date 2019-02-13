import CloudKit

private let categoryRecordType = "Category"
private let ingredientUnitRecordType = "IngredientUnit"
private let recipeRecordType = "Recipe"
private let ingredientRecordType = "Ingredient"
private let recipesPredicateFormat = "category == %@"
private let recipePredicateFormat = "recipe == %@"
private let nameKey = "name"
private let photoKey = "photo"
private let resultsLimit = 10

class CloudKitAPI: API {
    private let container: CKContainer
    private let publicDatabase: CKDatabase
    private let privateDatabase: CKDatabase

    init(container: CKContainer = CKContainer.default()) {
        self.container = container
        publicDatabase = container.publicCloudDatabase
        privateDatabase = container.privateCloudDatabase
    }

    // MARK: - Account

    func getAccountStatus(success: @escaping Success<Void>, failure: @escaping Failure) {
        container.accountStatus { status, _ in
            DispatchQueue.main.async {
                if status == .available {
                    success(())
                } else {
                    let error = RecipesError(message: nil)
                    failure(error)
                }
            }
        }
    }

    // MARK: - Category

    func getCategories(success: @escaping Success<[Category]>, failure: @escaping Failure) {
        let query = QueryBuilder(recordType: categoryRecordType).addSortDescriptor().build()
        publicDatabase.perform(query, inZoneWith: nil) { results, error in
            DispatchQueue.main.async {
                guard let results = results else {
                    let error = RecipesError(message: error?.localizedDescription)
                    failure(error)
                    return
                }

                let categories = results.map { CloudKitCategoryAdapter.adapt($0) }
                success(categories)
            }
        }
    }

    // MARK: - Ingredient unit

    func getIngredientUnits(success: @escaping Success<[IngredientUnit]>, failure: @escaping Failure) {
        let query = QueryBuilder(recordType: ingredientUnitRecordType).addSortDescriptor().build()
        publicDatabase.perform(query, inZoneWith: nil) { results, error in
            DispatchQueue.main.async {
                guard let results = results else {
                    let error = RecipesError(message: error?.localizedDescription)
                    failure(error)
                    return
                }

                let ingredientUnits = results.map { CloudKitIngredientUnitAdapter.adapt($0) }
                success(ingredientUnits)
            }
        }
    }

    // MARK: - Recipe

    func getRecipes(categoryIdentifier: String,
                    cursor: Any?,
                    success: @escaping Success<Page<Recipe>>,
                    failure: @escaping Failure) {

        var recipes = [Recipe]()

        let queryOperation: CKQueryOperation!
        if let cursor = cursor as? CKQueryOperation.Cursor {
            queryOperation = CKQueryOperation(cursor: cursor)
        } else {
            let query = QueryBuilder(recordType: recipeRecordType)
                .addSortDescriptor(ascending: false)
                .addPredicate(format: recipesPredicateFormat, argument: categoryIdentifier)
                .build()

            queryOperation = CKQueryOperation(query: query)
        }

        queryOperation.resultsLimit = resultsLimit
        queryOperation.desiredKeys = [nameKey, photoKey]
        queryOperation.recordFetchedBlock = { record in
            let recipe = CloudKitRecipeAdapter.adapt(record)
            recipes.append(recipe)
        }
        queryOperation.queryCompletionBlock = { cursor, cloudError in
            DispatchQueue.main.async {
                guard let cloudError = cloudError else {
                    recipes.sort { $0.createdDate > $1.createdDate }
                    let page = Page(result: recipes, cursor: cursor)
                    success(page)
                    return
                }

                let resipesError = RecipesError(message: cloudError.localizedDescription)
                failure(resipesError)
            }
        }

        privateDatabase.add(queryOperation)
    }

    func getRecipe(identifier: String,
                   ingredientUnits: [IngredientUnit],
                   success: @escaping Success<Recipe>,
                   failure: @escaping Failure) {

        let recordId = CKRecord.ID(recordName: identifier)
        privateDatabase.fetch(withRecordID: recordId) { [weak self] record, error in
            DispatchQueue.main.async {
                guard let self = self, let record = record else {
                    let error = RecipesError(message: error?.localizedDescription)
                    failure(error)
                    return
                }

                let recordId = CKRecord.ID(recordName: identifier)
                let query = QueryBuilder(recordType: ingredientRecordType)
                    .addSortDescriptor()
                    .addPredicate(format: recipePredicateFormat, argument: recordId)
                    .build()

                self.privateDatabase.perform(query, inZoneWith: nil) { results, error in
                    DispatchQueue.main.async {
                        guard let results = results else {
                            let error = RecipesError(message: error?.localizedDescription)
                            failure(error)
                            return
                        }

                        let recipe = CloudKitRecipeAdapter.adapt(record, results, ingredientUnits)
                        success(recipe)
                    }
                }
            }
        }
    }

    func createRecipe(recipe: Recipe, success: @escaping Success<Void>, failure: @escaping Failure) {
        let recordsToSave = CloudKitRecipeAdapter.adapt(recipe)
        let operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: nil)
        operation.modifyRecordsCompletionBlock = { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    let error = RecipesError(message: error.localizedDescription)
                    failure(error)
                } else {
                    success(())
                }
            }
        }
        operation.start()
    }

    func deleteRecipe(identifier: String, success: @escaping Success<Void>, failure: @escaping Failure) {
        let recordId = CKRecord.ID(recordName: identifier)
        privateDatabase.delete(withRecordID: recordId) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    let error = RecipesError(message: error.localizedDescription)
                    failure(error)
                } else {
                    success(())
                }
            }
        }
    }
}
