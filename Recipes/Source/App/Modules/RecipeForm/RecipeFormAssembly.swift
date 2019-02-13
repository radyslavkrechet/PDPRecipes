import Swinject

class RecipeFormAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.storyboardInitCompleted(RecipeFormViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(RecipeFormViewModel.self)!
            controller.tableProvider = resolver.resolve(RecipeFormTableProvider.self)!
        }

        container.register(RecipeFormViewModel.self) { resolver in
            let createRecipeUseCase = resolver.resolve(CreateRecipeUseCase.self)!
            return RecipeFormViewModel(createRecipeUseCase: createRecipeUseCase)
        }

        container.register(RecipeFormTableProvider.self) { _ in
            return RecipeFormTableProvider()
        }
    }
}
