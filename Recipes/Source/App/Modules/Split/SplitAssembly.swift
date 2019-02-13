import Swinject

class SplitAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.storyboardInitCompleted(SplitViewController.self) { resolver, controller in
            controller.splitProvider = resolver.resolve(SplitProvider.self)!
        }

        container.register(SplitProvider.self) { _ in
            return SplitProvider()
        }
    }
}
