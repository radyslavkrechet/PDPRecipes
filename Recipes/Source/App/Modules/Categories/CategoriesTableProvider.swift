import UIKit

// swiftlint:disable anyobject_protocol
protocol CategoriesTableProviderDelegate: class {
    var tableView: UITableView! { get }

    func provider(_ provider: CategoriesTableProvider, didSelect category: Category)
}
// swiftlint:enable anyobject_protocol

class CategoriesTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: CategoriesTableProviderDelegate?

    private var categories = [Category]()

    func insert(_ categories: [Category]) {
        self.categories = categories
        let indexPathes = (0..<categories.count).map { IndexPath(row: $0, section: 0) }
        delegate?.tableView.insertRows(at: indexPathes, with: .automatic)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell: CategoryTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        cell.populate(with: category)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let category = categories[indexPath.row]
        delegate?.provider(self, didSelect: category)
    }
}
