import Foundation

struct CoreDataIngredientUnitAdapter {
    static func adapt(_ entity: IngredientUnitEntity) -> IngredientUnit {
        let identifier = entity.identifier ?? String()
        let name = entity.name ?? String()
        let createdDate = entity.createdDate ?? Date()
        return IngredientUnit(identifier: identifier, name: name, createdDate: createdDate)
    }

    static func update(_ entity: IngredientUnitEntity, with ingredientUnit: IngredientUnit) {
        entity.identifier = ingredientUnit.identifier
        entity.name = ingredientUnit.name
        entity.createdDate = ingredientUnit.createdDate
    }
}
