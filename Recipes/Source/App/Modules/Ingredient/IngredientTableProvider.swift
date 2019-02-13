import UIKit

private enum IngredientBaseSectionRow: Int, CaseIterable {
    case name
    case number
}

private enum IngredientSection: Int, CaseIterable {
    case base
    case units
}

// swiftlint:disable anyobject_protocol
protocol IngredientTableProviderDelegate: class {
    var tableView: UITableView! { get }

    func provider(_ provider: IngredientTableProvider, didDequeueNameTextField textField: UITextField)
    func provider(_ provider: IngredientTableProvider, didDequeueNumberTextField textField: UITextField)
    func provider(_ provider: IngredientTableProvider, didSelectIngredientUnitAtIndex index: Int)
}
// swiftlint:enable anyobject_protocol

class IngredientTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: IngredientTableProviderDelegate?

    private var ingredientUnits = [IngredientUnit]()
    private var indexPathOfSelectedIngredientUnit: IndexPath?

    func insert(_ ingredientUnits: [IngredientUnit]) {
        self.ingredientUnits = ingredientUnits
        let indexPathes = (0..<ingredientUnits.count).map {
            IndexPath(row: $0, section: IngredientSection.units.rawValue)
        }
        delegate?.tableView.insertRows(at: indexPathes, with: .automatic)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return IngredientSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case IngredientSection.base.rawValue:
            return IngredientBaseSectionRow.allCases.count
        case IngredientSection.units.rawValue:
            return ingredientUnits.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case IngredientSection.base.rawValue:
            return baseCell(with: tableView, indexPath: indexPath)
        case IngredientSection.units.rawValue:
            return unitCell(with: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var indexPathes = [indexPath]
        let previousIndexPath = indexPathOfSelectedIngredientUnit
        indexPathOfSelectedIngredientUnit = indexPath
        if let previousIndexPath = previousIndexPath {
            indexPathes.append(previousIndexPath)
        }
        tableView.reloadRows(at: indexPathes, with: .automatic)

        delegate?.provider(self, didSelectIngredientUnitAtIndex: indexPath.row)
    }

    // MARK: - Private

    private func baseCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case IngredientBaseSectionRow.name.rawValue:
            return nameCell(with: tableView, indexPath: indexPath)
        case IngredientBaseSectionRow.number.rawValue:
            return numberCell(with: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func nameCell(with tableView: UITableView, indexPath: IndexPath) -> IngredientNameTableViewCell {
        let cell: IngredientNameTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        delegate?.provider(self, didDequeueNameTextField: cell.nameTextField)
        return cell
    }

    private func numberCell(with tableView: UITableView, indexPath: IndexPath) -> IngredientNumberTableViewCell {
        let cell: IngredientNumberTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        delegate?.provider(self, didDequeueNumberTextField: cell.numberTextField)
        return cell
    }

    private func unitCell(with tableView: UITableView, indexPath: IndexPath) -> IngredientUnitTableViewCell {
        let ingredientUnit = ingredientUnits[indexPath.row]
        let cell: IngredientUnitTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        cell.accessoryType = indexPathOfSelectedIngredientUnit?.row == indexPath.row ? .checkmark : .none
        cell.populate(with: ingredientUnit.name)
        return cell
    }
}
