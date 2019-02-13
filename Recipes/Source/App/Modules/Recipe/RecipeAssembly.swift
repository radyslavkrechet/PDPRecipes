import Swinject

class RecipeAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.storyboardInitCompleted(RecipeViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(RecipeViewModel.self)!
        }

        container.register(RecipeViewModel.self) { resolver in
            let getRecipeUseCase = resolver.resolve(GetRecipeUseCase.self)!
            let deleteRecipeUseCase = resolver.resolve(DeleteRecipeUseCase.self)!
            return RecipeViewModel(getRecipeUseCase: getRecipeUseCase, deleteRecipeUseCase: deleteRecipeUseCase)
        }
    }
}
