import UIKit

class StepTableViewCell: UITableViewCell, UITextFieldDelegate {
    // swiftlint:disable private_outlet
    @IBOutlet private(set) weak var stepTextField: UITextField!
    // swiftlint:enable private_outlet
}
