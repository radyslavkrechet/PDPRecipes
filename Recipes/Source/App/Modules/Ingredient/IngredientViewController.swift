import UIKit

// swiftlint:disable anyobject_protocol
protocol IngredientViewControllerDelegate: class {
    func viewCotroller(_ viewCotroller: IngredientViewController, didProvide ingredient: Ingredient)
}
// swiftlint:enable anyobject_protocol

class IngredientViewController: ViewController<IngredientViewModel>, IngredientTableProviderDelegate {
    // swiftlint:disable private_outlet
    @IBOutlet private(set) weak var tableView: UITableView!
    // swiftlint:enable private_outlet

    var tableProvider: IngredientTableProvider!
    weak var delegate: IngredientViewControllerDelegate?

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
        getData()
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.registerNibForCell(IngredientNameTableViewCell.self)
        tableView.registerNibForCell(IngredientNumberTableViewCell.self)
        tableView.registerNibForCell(IngredientUnitTableViewCell.self)
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
        tableProvider.delegate = self
    }

    private func setupViewModel() {
        viewModel.ingredientUnits.asObservable().subscribe(onNext: { [weak self] ingredientUnits in
            self?.proccess(ingredientUnits)
        }).disposed(by: disposeBag)

        viewModel.ingredient.subscribe(onNext: { [weak self] ingredient in
            self?.proccess(ingredient)
        }).disposed(by: disposeBag)

        viewModel.isDataProvided.subscribe(onNext: { [weak self] isDataProvided in
            self?.process(isDataProvided)
        }).disposed(by: disposeBag)

        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: viewModel.addDidTap)
            .disposed(by: disposeBag)
    }

    private func getData() {
        viewModel.getIngredientUnits()
    }

    private func proccess(_ ingredientUnits: [IngredientUnit]) {
        tableProvider.insert(ingredientUnits)
    }

    private func proccess(_ ingredient: Ingredient) {
        delegate?.viewCotroller(self, didProvide: ingredient)
        navigationController?.popViewController(animated: true)
    }

    private func process(_ isDataProvided: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isDataProvided
    }

    // MARK: - IngredientTableProviderDelegate

    func provider(_ provider: IngredientTableProvider, didDequeueNameTextField textField: UITextField) {
        textField.rx.text.orEmpty
            .bind(to: viewModel.nameVariable)
            .disposed(by: disposeBag)
    }

    func provider(_ provider: IngredientTableProvider, didDequeueNumberTextField textField: UITextField) {
        textField.rx.text.orEmpty
            .bind(to: viewModel.numberVariable)
            .disposed(by: disposeBag)
    }

    func provider(_ provider: IngredientTableProvider, didSelectIngredientUnitAtIndex index: Int) {
        viewModel.indexOfSelectedIngredientUnitVariable.value = index
    }
}
