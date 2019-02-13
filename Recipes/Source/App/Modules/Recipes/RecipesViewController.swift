import UIKit

class RecipesViewController: CollectionViewController<RecipesViewModel>,
    RecipesCollectionProviderDelegate,
    RecipeViewControllerDelegate,
    RecipeFormViewControllerDelegate {

    var collectionProvider: RecipesCollectionProvider!
    var categoryIdentifier: String!
    override var emptyStateMessage: String {
        return "recipesViewController.emptyStateMessage".localized()
    }

    private var selectedRecipeIdentifier: String!

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupViewModel()
        getData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipeViewController = segue.destination as? RecipeViewController {
            recipeViewController.recipeIdentifier = selectedRecipeIdentifier
            recipeViewController.delegate = self
        } else if let navigationController = segue.destination as? UINavigationController,
            let recipeFormViewController = navigationController.topViewController as? RecipeFormViewController {

            recipeFormViewController.categoryIdentifier = categoryIdentifier
            recipeFormViewController.delegate = self
        }
    }

    // MARK: - Setup

    private func setupCollectionView() {
        collectionView.registerNibForCell(RecipeCollectionViewCell.self)
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
        collectionProvider.delegate = self
    }

    private func setupViewModel() {
        viewModel.categoryIdentifier = categoryIdentifier

        viewModel.recipes.subscribe(onNext: { [weak self] recipes in
            self?.proccess(recipes)
        }).disposed(by: disposeBag)
    }

    private func getData() {
        if categoryIdentifier != nil {
            viewModel.getRecipes()
        }
    }

    private func proccess(_ recipes: [Recipe]) {
        refreshControl.endRefreshing()
        collectionProvider.set(recipes)
    }

    // MARK: - PageViewController

    override func refreshControlDidPull(_ refreshControl: UIRefreshControl) {
        viewModel.refreshRecipes()
    }

    // MARK: - RecipesCollectionProviderDelegate

    func provider(_ provider: RecipesCollectionProvider, didSelectRecipeWithIdentifier identifier: String) {
        selectedRecipeIdentifier = identifier
        performSegue(withIdentifier: SegueIdentifiers.toRecipe, sender: provider)
    }

    func providerWillDisplayLastRecipe(_ provider: RecipesCollectionProvider) {
        getData()
    }

    // MARK: - RecipeViewControllerDelegate

    func viewControllerDidDeleteRecipe(_ controller: RecipeViewController) {
        viewModel.refreshRecipes()
    }

    // MARK: - RecipeFormViewControllerDelegate

    func viewControllerDidCreateRecipe(_ controller: RecipeFormViewController) {
        viewModel.refreshRecipes()
    }
}
