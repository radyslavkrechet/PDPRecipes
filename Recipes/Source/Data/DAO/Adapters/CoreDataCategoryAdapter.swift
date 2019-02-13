import Foundation

struct CoreDataCategoryAdapter {
    static func adapt(_ entity: CategoryEntity) -> Category {
        let identifier = entity.identifier ?? String()
        let name = entity.name ?? String()
        let icon = entity.icon ?? Data()
        let createdDate = entity.createdDate ?? Date()
        return Category(identifier: identifier, name: name, icon: icon, createdDate: createdDate)
    }

    static func update(_ entity: CategoryEntity, with category: Category) {
        entity.identifier = category.identifier
        entity.name = category.name
        entity.icon = category.icon
        entity.createdDate = category.createdDate
    }
}
