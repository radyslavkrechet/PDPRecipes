import UIKit

private enum RecipeFormBaseSectionRow: Int, CaseIterable {
    case photo
    case name
    case note
}

private enum RecipeFormSection: Int, CaseIterable {
    case base
    case ingredients
    case steps
}

// swiftlint:disable anyobject_protocol
protocol RecipeFormTableProviderDelegate: class {
    var tableView: UITableView! { get }

    func provider(_ provider: RecipeFormTableProvider, didDequeueNameTextField textField: UITextField)
    func provider(_ provider: RecipeFormTableProvider, didDequeueNoteTextField textField: UITextField)
    func providerDidSelectAddPhoto(_ provider: RecipeFormTableProvider)
    func providerDidSelectAddIngredient(_ provider: RecipeFormTableProvider)
    func providerDidSelectAddStep(_ provider: RecipeFormTableProvider)
}
// swiftlint:enable anyobject_protocol

class RecipeFormTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: RecipeFormTableProviderDelegate?

    private var image: UIImage?
    private var ingredients = [Ingredient]()
    private var steps = [String]()

    func insert(_ image: UIImage) {
        self.image = image
        let indexPath = IndexPath(row: RecipeFormBaseSectionRow.photo.rawValue,
                                  section: RecipeFormSection.base.rawValue)

        delegate?.tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func insert(_ ingredient: Ingredient) {
        let indexPath = IndexPath(row: ingredients.count, section: RecipeFormSection.ingredients.rawValue)
        ingredients.append(ingredient)
        delegate?.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func insert(_ step: String) {
        let indexPath = IndexPath(row: steps.count, section: RecipeFormSection.steps.rawValue)
        steps.append(step)
        delegate?.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return RecipeFormSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case RecipeFormSection.base.rawValue:
            return RecipeFormBaseSectionRow.allCases.count
        case RecipeFormSection.ingredients.rawValue:
            return ingredients.count + 1
        case RecipeFormSection.steps.rawValue:
            return steps.count + 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case RecipeFormSection.base.rawValue:
            return baseCell(with: tableView, indexPath: indexPath)
        case RecipeFormSection.ingredients.rawValue:
            return ingredientCell(with: tableView, indexPath: indexPath)
        case RecipeFormSection.steps.rawValue:
            return stepCell(with: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let delegate = delegate else {
            return
        }

        switch indexPath.section {
        case RecipeFormSection.base.rawValue:
            if indexPath.row == RecipeFormBaseSectionRow.photo.rawValue {
                delegate.providerDidSelectAddPhoto(self)
            }
        case RecipeFormSection.ingredients.rawValue:
            if ingredients.count == indexPath.row {
                delegate.providerDidSelectAddIngredient(self)
            }
        case RecipeFormSection.steps.rawValue:
            if steps.count == indexPath.row {
                delegate.providerDidSelectAddStep(self)
            }
        default:
            return
        }
    }

    // MARK: - Private

    private func baseCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case RecipeFormBaseSectionRow.photo.rawValue:
            return photoCell(with: tableView, indexPath: indexPath)
        case RecipeFormBaseSectionRow.name.rawValue:
            return nameCell(with: tableView, indexPath: indexPath)
        case RecipeFormBaseSectionRow.note.rawValue:
            return noteCell(with: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func photoCell(with tableView: UITableView, indexPath: IndexPath) -> RecipePhotoTableViewCell {
        let cell: RecipePhotoTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        if let image = image {
            cell.populate(with: image)
        }
        return cell
    }

    private func nameCell(with tableView: UITableView, indexPath: IndexPath) -> RecipeNameTableViewCell {
        let cell: RecipeNameTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        delegate?.provider(self, didDequeueNameTextField: cell.nameTextField)
        return cell
    }

    private func noteCell(with tableView: UITableView, indexPath: IndexPath) -> RecipeNoteTableViewCell {
        let cell: RecipeNoteTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        delegate?.provider(self, didDequeueNoteTextField: cell.noteTextField)
        return cell
    }

    private func ingredientCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if ingredients.count > indexPath.row {
            return ingredientItemCell(with: tableView, indexPath: indexPath)
        } else {
            return ingredientActionCell(with: tableView, indexPath: indexPath)
        }
    }

    private func ingredientItemCell(with tableView: UITableView, indexPath: IndexPath) -> RecipeItemTableViewCell {
        let ingredient = ingredients[indexPath.row]
        let cell: RecipeItemTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        cell.populate(with: ingredient.details)
        return cell
    }

    private func ingredientActionCell(with tableView: UITableView, indexPath: IndexPath) -> RecipeActionTableViewCell {
        let cell: RecipeActionTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        cell.populate(with: "recipeFormTableProvider.addIngredient".localized())
        return cell
    }

    private func stepCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if steps.count > indexPath.row {
            return stepItemCell(with: tableView, indexPath: indexPath)
        } else {
            return stepActionCell(with: tableView, indexPath: indexPath)
        }
    }

    private func stepItemCell(with tableView: UITableView, indexPath: IndexPath) -> RecipeItemTableViewCell {
        let step = steps[indexPath.row]
        let cell: RecipeItemTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        cell.populate(with: step)
        return cell
    }

    private func stepActionCell(with tableView: UITableView, indexPath: IndexPath) -> RecipeActionTableViewCell {
        let cell: RecipeActionTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        cell.populate(with: "recipeFormTableProvider.addStep".localized())
        return cell
    }
}
