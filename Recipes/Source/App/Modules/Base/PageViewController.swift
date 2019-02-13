import UIKit

class PageViewController<T: PageViewModel>: ViewController<T> {
    var refreshControl: UIRefreshControl!

    // MARK: - Methods to override

    // swiftlint:disable attributes
    @objc func refreshControlDidPull(_ refreshControl: UIRefreshControl) {
        assert(false, "refreshControlDidPull() has not been implemented")
    }
    // swiftlint:enable attributes
}
