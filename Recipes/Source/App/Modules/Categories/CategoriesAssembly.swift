import Swinject

class CategoriesAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.storyboardInitCompleted(CategoriesViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(CategoriesViewModel.self)!
            controller.tableProvider = resolver.resolve(CategoriesTableProvider.self)!
        }

        container.register(CategoriesViewModel.self) { resolver in
            let getCategoriesUseCase = resolver.resolve(GetCategoriesUseCase.self)!
            return CategoriesViewModel(getCategoriesUseCase: getCategoriesUseCase)
        }

        container.register(CategoriesTableProvider.self) { _ in
            return CategoriesTableProvider()
        }
    }
}
