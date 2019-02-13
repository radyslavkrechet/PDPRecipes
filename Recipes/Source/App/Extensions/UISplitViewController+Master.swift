import UIKit

extension UISplitViewController {
    func hideMaster() {
        if let action = displayModeButtonItem.action {
            UIApplication.shared.sendAction(action,
                                            to: displayModeButtonItem.target,
                                            from: nil,
                                            for: nil)
        }
    }
}
