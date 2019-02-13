import UIKit

extension UITableView {
    func registerNibForCell<T: UITableViewCell>(_ cell: T.Type) {
        let cellNib = UINib(nibName: T.nameOfClass, bundle: nil)
        register(cellNib, forCellReuseIdentifier: T.nameOfClass)
    }

    func dequeueReusableCellForIndexPath<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.nameOfClass, for: indexPath) as? T ?? T()
    }
}
