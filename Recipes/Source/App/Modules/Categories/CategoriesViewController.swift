import UIKit

class CategoriesViewController: ViewController<CategoriesViewModel>, CategoriesTableProviderDelegate {
    // swiftlint:disable private_outlet
    @IBOutlet private(set) weak var tableView: UITableView!
    // swiftlint:enable private_outlet

    var tableProvider: CategoriesTableProvider!

    private var selectedCategory: Category!

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
        getData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let recipesViewController = navigationController.topViewController as? RecipesViewController {

            recipesViewController.title = selectedCategory.name.localized()
            recipesViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            recipesViewController.navigationItem.leftItemsSupplementBackButton = true
            recipesViewController.categoryIdentifier = selectedCategory.identifier
        }
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.registerNibForCell(CategoryTableViewCell.self)
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
        tableProvider.delegate = self
    }

    private func setupViewModel() {
        viewModel.categories.subscribe(onNext: { [weak self] categories in
            self?.proccess(categories)
        }).disposed(by: disposeBag)
    }

    private func getData() {
        viewModel.getCategories()
    }

    private func proccess(_ categories: [Category]) {
        tableProvider.insert(categories)

        if let navigationController = splitViewController?.viewControllers.last as? UINavigationController,
            navigationController.topViewController as? RecipesViewController != nil {

            selectedCategory = categories.first
            performSegue(withIdentifier: SegueIdentifiers.toRecipes, sender: self)
        }
    }

    // MARK: - CategoriesTableProviderDelegate

    func provider(_ provider: CategoriesTableProvider, didSelect category: Category) {
        selectedCategory = category
        splitViewController?.hideMaster()
        performSegue(withIdentifier: SegueIdentifiers.toRecipes, sender: provider)
    }
}
