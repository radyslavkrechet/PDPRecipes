import Swinject

class StepAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.storyboardInitCompleted(StepViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(StepViewModel.self)!
            controller.tableProvider = resolver.resolve(StepTableProvider.self)!
        }

        container.register(StepViewModel.self) { _ in
            return StepViewModel()
        }

        container.register(StepTableProvider.self) { _ in
            return StepTableProvider()
        }
    }
}
