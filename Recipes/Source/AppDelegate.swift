import Swinject
import SwinjectStoryboard
import UIKit

private let mainStoryboardName = "Main"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let assembler = Assembler()

    // MARK: - Setup

    private func setupAssembler() {
        let data = DataAssembly()
        let domain = DomainAssembly()
        let splitModule = SplitAssembly()
        let preloadModule = PreloadAssembly()
        let categoriesModule = CategoriesAssembly()
        let recipesModule = RecipesAssembly()
        let recipeModule = RecipeAssembly()
        let recipeFormModule = RecipeFormAssembly()
        let ingredientModule = IngredientAssembly()
        let stepModule = StepAssembly()
        let assemblies: [Assembly] = [data,
                                      domain,
                                      splitModule,
                                      preloadModule,
                                      categoriesModule,
                                      recipesModule,
                                      recipeModule,
                                      recipeFormModule,
                                      ingredientModule,
                                      stepModule]

        assembler.apply(assemblies: assemblies)
    }

    private func setupWindow() {
        let storyboard = SwinjectStoryboard.create(name: mainStoryboardName,
                                                   bundle: nil,
                                                   container: assembler.resolver)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Disabled logging due errors
        // https://github.com/Swinject/Swinject/issues/218
        Container.loggingFunction = nil

        setupAssembler()
        setupWindow()
        return true
    }

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        return UIDevice.current.userInterfaceIdiom == .phone ? .portrait : .allButUpsideDown
    }
}
