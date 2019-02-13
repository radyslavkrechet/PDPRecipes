import CoreStore

private let createdDateKey = "createdDate"

class CoreDataDAO: DAO {
    init() {
        do {
            try CoreStore.addStorageAndWait()
        } catch {
            assert(false, error.localizedDescription)
        }
    }

    // MARK: - Category

    func getCategories(success: @escaping Success<[Category]>, failure: @escaping Failure) {
        let adapt: (CategoryEntity) -> Category = { entity in
            return CoreDataCategoryAdapter.adapt(entity)
        }
        fetch(adapt: adapt, success: success, failure: failure)
    }

    func createCategories(categories: [Category], success: @escaping Success<Void>, failure: @escaping Failure) {
        let update: (CategoryEntity, Category) -> Void = { entity, category in
            CoreDataCategoryAdapter.update(entity, with: category)
        }
        save(objects: categories, update: update, success: success, failure: failure)
    }

    // MARK: - Ingredient unit

    func getIngredientUnits(success: @escaping Success<[IngredientUnit]>, failure: @escaping Failure) {
        let adapt: (IngredientUnitEntity) -> IngredientUnit = { entity in
            return CoreDataIngredientUnitAdapter.adapt(entity)
        }
        fetch(adapt: adapt, success: success, failure: failure)
    }

    func createIngredientUnits(ingredientUnits: [IngredientUnit],
                               success: @escaping Success<Void>,
                               failure: @escaping Failure) {

        let update: (IngredientUnitEntity, IngredientUnit) -> Void = { entity, ingredientUnit in
            CoreDataIngredientUnitAdapter.update(entity, with: ingredientUnit)
        }
        save(objects: ingredientUnits, update: update, success: success, failure: failure)
    }

    // MARK: - Private

    private func fetch<Entity: DynamicObject, T>(adapt: @escaping (Entity) -> T,
                                                 success: @escaping Success<[T]>,
                                                 failure: @escaping Failure) {

        CoreStore.perform(asynchronous: { transaction -> [Entity] in
            let from = From<Entity>()
            let orderBy = OrderBy<Entity>(.ascending(createdDateKey))
            return transaction.fetchAll(from, orderBy) ?? []
        }, success: { entities in
            let result = entities.map { adapt($0) }
            success(result)
        }, failure: { storeError in
            let recipesError = RecipesError(message: storeError.localizedDescription)
            failure(recipesError)
        })
    }

    private func save<Entity: DynamicObject, T>(objects: [T],
                                                update: @escaping (Entity, T) -> Void,
                                                success: @escaping Success<Void>,
                                                failure: @escaping Failure) {

        CoreStore.perform(asynchronous: { transaction -> Void in
            objects.forEach {
                let entity = transaction.create(Into<Entity>())
                update(entity, $0)
            }
        }, success: { result in
            success(result)
        }, failure: { storeError in
            let recipesError = RecipesError(message: storeError.localizedDescription)
            failure(recipesError)
        })
    }
}
