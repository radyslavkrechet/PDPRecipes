import Swinject

class DomainAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {

        // MARK: - Preload

        container.register(GetAccountStatusUseCase.self) { resolver in
            let repository = resolver.resolve(AccountRepository.self)!
            return GetAccountStatusUseCase(repository: repository)
        }

        // MARK: - Recipes

        container.register(GetRecipesUseCase.self) { resolver in
            let repository = resolver.resolve(RecipeRepository.self)!
            return GetRecipesUseCase(repository: repository)
        }

        // MARK: - Recipe

        container.register(DeleteRecipeUseCase.self) { resolver in
            let repository = resolver.resolve(RecipeRepository.self)!
            return DeleteRecipeUseCase(repository: repository)
        }

        container.register(GetRecipeUseCase.self) { resolver in
            let repository = resolver.resolve(RecipeRepository.self)!
            return GetRecipeUseCase(repository: repository)
        }

        // MARK: - RecipeForm

        container.register(CreateRecipeUseCase.self) { resolver in
            let repository = resolver.resolve(RecipeRepository.self)!
            return CreateRecipeUseCase(repository: repository)
        }

        // MARK: - Shared

        container.register(GetCategoriesUseCase.self) { resolver in
            let repository = resolver.resolve(CategoryRepository.self)!
            return GetCategoriesUseCase(repository: repository)
        }

        container.register(GetIngredientUnitsUseCase.self) { resolver in
            let repository = resolver.resolve(IngredientUnitRepository.self)!
            return GetIngredientUnitsUseCase(repository: repository)
        }
    }
}
