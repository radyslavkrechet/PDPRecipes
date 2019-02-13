import UIKit

class SplitViewController: UISplitViewController {
    var splitProvider: SplitProvider!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        if let navigationController = viewControllers.last as? UINavigationController,
            let viewController = navigationController.topViewController {

            delegate = splitProvider
            viewController.navigationItem.leftBarButtonItem = displayModeButtonItem
            viewController.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}
