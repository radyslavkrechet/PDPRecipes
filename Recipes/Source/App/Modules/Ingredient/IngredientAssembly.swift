import Swinject

class IngredientAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.storyboardInitCompleted(IngredientViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(IngredientViewModel.self)!
            controller.tableProvider = resolver.resolve(IngredientTableProvider.self)!
        }

        container.register(IngredientViewModel.self) { resolver in
            let getIngredientUnitsUseCase = resolver.resolve(GetIngredientUnitsUseCase.self)!
            return IngredientViewModel(getIngredientUnitsUseCase: getIngredientUnitsUseCase)
        }

        container.register(IngredientTableProvider.self) { _ in
            return IngredientTableProvider()
        }
    }
}
