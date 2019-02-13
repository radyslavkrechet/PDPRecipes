import Swinject

class DataAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {

        // MARK: - API

        container.register(API.self) { _ in
            return CloudKitAPI()
        }.inObjectScope(.container)

        // MARK: - DAO

        container.register(DAO.self) { _ in
            return CoreDataDAO()
        }.inObjectScope(.container)

        // MARK: - Repositories

        container.register(AccountRepository.self) { resolver in
            let api = resolver.resolve(API.self)!
            return RecipesAccountRepository(api: api)
        }.inObjectScope(.container)

        container.register(CategoryRepository.self) { resolver in
            let api = resolver.resolve(API.self)!
            let dao = resolver.resolve(DAO.self)!
            return RecipesCategoryRepository(api: api, dao: dao)
        }.inObjectScope(.container)

        container.register(IngredientUnitRepository.self) { resolver in
            let api = resolver.resolve(API.self)!
            let dao = resolver.resolve(DAO.self)!
            return RecipesIngredientUnitRepository(api: api, dao: dao)
        }.inObjectScope(.container)

        container.register(RecipeRepository.self) { resolver in
            let api = resolver.resolve(API.self)!
            let dao = resolver.resolve(DAO.self)!
            return RecipesRecipeRepository(api: api, dao: dao)
        }.inObjectScope(.container)
    }
}
