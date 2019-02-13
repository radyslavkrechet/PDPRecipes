import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Setup

    func populate(with category: Category) {
        iconImageView.image = UIImage(data: category.icon)
        nameLabel.text = category.name.localized()
    }
}
