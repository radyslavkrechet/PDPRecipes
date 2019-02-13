import UIKit

// swiftlint:disable anyobject_protocol
protocol StepTableProviderDelegate: class {
    func provider(_ provider: StepTableProvider, didDequeueStepTextField textField: UITextField)
}
// swiftlint:enable anyobject_protocol

class StepTableProvider: NSObject, UITableViewDataSource {
    weak var delegate: StepTableProviderDelegate?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StepTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        delegate?.provider(self, didDequeueStepTextField: cell.stepTextField)
        return cell
    }
}
