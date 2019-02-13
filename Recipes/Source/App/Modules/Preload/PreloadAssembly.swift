import Swinject

class PreloadAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.storyboardInitCompleted(PreloadViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(PreloadViewModel.self)!
        }

        container.register(PreloadViewModel.self) { resolver in
            let getAccountStatusUseCase = resolver.resolve(GetAccountStatusUseCase.self)!
            let getCategoriesUseCase = resolver.resolve(GetCategoriesUseCase.self)!
            let getIngredientUnitsUseCase = resolver.resolve(GetIngredientUnitsUseCase.self)!
            return PreloadViewModel(getAccountStatusUseCase: getAccountStatusUseCase,
                                    getCategoriesUseCase: getCategoriesUseCase,
                                    getIngredientUnitsUseCase: getIngredientUnitsUseCase)
        }
    }
}
