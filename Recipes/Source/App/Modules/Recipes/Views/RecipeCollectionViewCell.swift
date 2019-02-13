import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - View lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.image = nil
    }

    // MARK: - Setup

    func populate(with recipe: Recipe) {
        if let url = recipe.photo, let data = try? Data(contentsOf: url) {
            photoImageView.image = UIImage(data: data)
        }
        nameLabel.text = recipe.name
    }
}
