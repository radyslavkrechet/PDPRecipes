import UIKit

class EmptyView: View {
    @IBOutlet private weak var textLabel: UILabel!

    // MARK: - Setup

    func populate(with text: String) {
        textLabel.text = text
    }
}
