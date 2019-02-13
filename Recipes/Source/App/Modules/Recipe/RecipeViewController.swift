import UIKit

// swiftlint:disable anyobject_protocol
protocol RecipeViewControllerDelegate: class {
    func viewControllerDidDeleteRecipe(_ controller: RecipeViewController)
}
// swiftlint:enable anyobject_protocol

class RecipeViewController: ViewController<RecipeViewModel> {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var noteLabbel: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var stepsLabel: UILabel!

    var recipeIdentifier: String!
    weak var delegate: RecipeViewControllerDelegate?

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        getData()
    }

    // MARK: - Setup

    private func setupViewModel() {
        viewModel.recipe.subscribe(onNext: { [weak self] recipe in
            self?.proccess(recipe)
        }).disposed(by: disposeBag)

        viewModel.didDeleteRecipe.subscribe(onNext: { [weak self] _ in
            self?.proccessRecipeDeleting()
        }).disposed(by: disposeBag)
    }

    private func getData() {
        viewModel.getRecipe(identifier: recipeIdentifier)
    }

    private func proccess(_ recipe: Recipe) {
        if let url = recipe.photo, let data = try? Data(contentsOf: url) {
            photoImageView.image = UIImage(data: data)
        }
        nameLabel.text = recipe.name
        noteLabbel.text = recipe.note
        ingredientsLabel.text = recipe.ingredientsDetails
        stepsLabel.text = recipe.stepsDetails
    }

    private func proccessRecipeDeleting() {
        delegate?.viewControllerDidDeleteRecipe(self)
        navigationController?.popViewController(animated: true)
    }

    private func presentAlert() {
        let deleteRecipeActionHandler: (UIAlertAction) -> Void = { _ in
            self.viewModel.deleteRecipe()
        }
        let deleteRecipeAction = UIAlertAction(title: "recipeViewController.alert.deleteRecipe".localized(),
                                               style: .destructive,
                                               handler: deleteRecipeActionHandler)

        let cancelAction = UIAlertAction(title: "recipeViewController.alert.cancel".localized(), style: .cancel)
        let alertViewController = UIAlertController(title: nil,
                                                    message: nil,
                                                    preferredStyle: .actionSheet)

        alertViewController.addAction(deleteRecipeAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true)
    }

    // MARK: - Actions

    @IBAction private func deleteBarButtonItemDidTap(_ sender: UIBarButtonItem) {
        presentAlert()
    }
}
