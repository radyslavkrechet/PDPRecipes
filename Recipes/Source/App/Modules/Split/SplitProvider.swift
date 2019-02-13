import UIKit

class SplitProvider: NSObject, UISplitViewControllerDelegate {

    // MARK: - UISplitViewControllerDelegate

    func splitViewController(_ svc: UISplitViewController,
                             willChangeTo displayMode: UISplitViewController.DisplayMode) {

        if let navigationController = svc.viewControllers.first as? UINavigationController,
            let viewController = navigationController.topViewController {

            viewController.navigationItem.leftBarButtonItem = nil
        }
    }

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {

        return true
    }
}
