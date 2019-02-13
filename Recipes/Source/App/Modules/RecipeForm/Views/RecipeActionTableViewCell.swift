import UIKit

class RecipeActionTableViewCell: UITableViewCell {

    // MARK: - Setup

    func populate(with nameOfAction: String) {
        textLabel?.text = nameOfAction
    }
}
