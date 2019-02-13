import UIKit

// swiftlint:disable anyobject_protocol
protocol RecipeFormViewControllerDelegate: class {
    func viewControllerDidCreateRecipe(_ controller: RecipeFormViewController)
}
// swiftlint:enable anyobject_protocol

class RecipeFormViewController: ViewController<RecipeFormViewModel>,
    RecipeFormTableProviderDelegate,
    IngredientViewControllerDelegate,
    StepViewControllerDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {

    // swiftlint:disable private_outlet
    @IBOutlet private(set) weak var tableView: UITableView!
    // swiftlint:enable private_outlet

    var tableProvider: RecipeFormTableProvider!
    var categoryIdentifier: String!
    weak var delegate: RecipeFormViewControllerDelegate?

    private let imagePickerController = UIImagePickerController()

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImagePickerController()
        setupTableView()
        setupViewModel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ingredientViewController = segue.destination as? IngredientViewController {
            ingredientViewController.delegate = self
        } else if let stepViewController = segue.destination as? StepViewController {
            stepViewController.delegate = self
        }
    }

    // MARK: - Setup

    private func setupImagePickerController() {
        imagePickerController.delegate = self
    }

    private func setupTableView() {
        tableView.registerNibForCell(RecipePhotoTableViewCell.self)
        tableView.registerNibForCell(RecipeNameTableViewCell.self)
        tableView.registerNibForCell(RecipeNoteTableViewCell.self)
        tableView.registerNibForCell(RecipeActionTableViewCell.self)
        tableView.registerNibForCell(RecipeItemTableViewCell.self)
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
        tableProvider.delegate = self
    }

    private func setupViewModel() {
        viewModel.categoryIdentifier = categoryIdentifier

        viewModel.didCreateRecipe.subscribe(onNext: { [weak self] _ in
            self?.proccessRecipeCreating()
        }).disposed(by: disposeBag)

        viewModel.isDataProvided.subscribe(onNext: { [weak self] isDataProvided in
            self?.process(isDataProvided)
        }).disposed(by: disposeBag)

        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: viewModel.doneDidTap)
            .disposed(by: disposeBag)
    }

    private func proccessRecipeCreating() {
        delegate?.viewControllerDidCreateRecipe(self)
        dismiss(animated: true)
    }

    private func process(_ isDataProvided: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isDataProvided
    }

    // MARK: - Actions

    @IBAction private func cancelBarButtonItemDidClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }

    // MARK: - RecipeFormTableProviderDelegate

    func provider(_ provider: RecipeFormTableProvider, didDequeueNameTextField textField: UITextField) {
        textField.rx.text.orEmpty
            .bind(to: viewModel.nameVariable)
            .disposed(by: disposeBag)
    }

    func provider(_ provider: RecipeFormTableProvider, didDequeueNoteTextField textField: UITextField) {
        textField.rx.text.orEmpty
            .bind(to: viewModel.noteVariable)
            .disposed(by: disposeBag)
    }

    func providerDidSelectAddPhoto(_ provider: RecipeFormTableProvider) {
        present(imagePickerController, animated: true)
    }

    func providerDidSelectAddIngredient(_ provider: RecipeFormTableProvider) {
        performSegue(withIdentifier: SegueIdentifiers.toIngredient, sender: provider)
    }

    func providerDidSelectAddStep(_ provider: RecipeFormTableProvider) {
        performSegue(withIdentifier: SegueIdentifiers.toStep, sender: provider)
    }

    // MARK: - IngredientViewControllerDelegate

    func viewCotroller(_ viewCotroller: IngredientViewController, didProvide ingredient: Ingredient) {
        viewModel.ingredientsVariable.value.append(ingredient)
        tableProvider.insert(ingredient)
    }

    // MARK: - StepViewControllerDelegate

    func viewCotroller(_ viewCotroller: StepViewController, didProvide step: String) {
        viewModel.stepsVariable.value.append(step)
        tableProvider.insert(step)
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        dismiss(animated: true)

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {

            viewModel.photoVariable.value = url
            tableProvider.insert(image)
        }
    }
}
