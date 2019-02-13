import UIKit

class CollectionViewController<T: PageViewModel>: PageViewController<T> {
    // swiftlint:disable private_outlet
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    // swiftlint:enable private_outlet

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()
    }

    // MARK: - Setup

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: Colors.brand)
        refreshControl.addTarget(self,
                                 action: #selector(CollectionViewController.refreshControlDidPull(_:)),
                                 for: .valueChanged)

        collectionView.refreshControl = refreshControl
    }
}
