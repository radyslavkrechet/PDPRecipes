import UIKit

class RecipeItemTableViewCell: UITableViewCell {

    // MARK: - Setup

    func populate(with item: String) {
        textLabel?.text = item
    }
}
