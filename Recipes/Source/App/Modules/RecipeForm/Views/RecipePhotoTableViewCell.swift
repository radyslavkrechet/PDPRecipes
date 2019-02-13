import UIKit

class RecipePhotoTableViewCell: UITableViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!

    // MARK: - Setup

    func populate(with image: UIImage) {
        photoImageView.image = image
    }
}
