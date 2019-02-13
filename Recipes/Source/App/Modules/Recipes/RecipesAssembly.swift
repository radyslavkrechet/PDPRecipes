import Swinject

class RecipesAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.storyboardInitCompleted(RecipesViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(RecipesViewModel.self)!
            controller.collectionProvider = resolver.resolve(RecipesCollectionProvider.self)!
        }

        container.register(RecipesViewModel.self) { resolver in
            let getRecipesUseCase = resolver.resolve(GetRecipesUseCase.self)!
            return RecipesViewModel(getRecipesUseCase: getRecipesUseCase)
        }

        container.register(RecipesCollectionProvider.self) { _ in
            return RecipesCollectionProvider()
        }
    }
}
