import UIKit

class IngredientUnitTableViewCell: UITableViewCell {

    // MARK: - Setup

    func populate(with unit: String) {
        textLabel?.text = unit
    }
}
