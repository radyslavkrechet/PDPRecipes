import UIKit

// swiftlint:disable anyobject_protocol
protocol ErrorViewDelegate: class {
    func viewDidTapTryAgain(_ view: ErrorView)
}
// swiftlint:enable anyobject_protocol

class ErrorView: View {
    @IBOutlet private weak var errorTextLabel: UILabel!
    @IBOutlet private weak var tryAgainButton: UIButton!

    weak var delegate: ErrorViewDelegate?

    // MARK: - Setup

    func populate(with error: RecipesError) {
        errorTextLabel.text = error.message ?? "errorView.unknownError".localized()
    }

    // MARK: - Actions

    @IBAction private func tryAgainButtonDidTap(_ sender: UIButton) {
        delegate?.viewDidTapTryAgain(self)
    }
}
