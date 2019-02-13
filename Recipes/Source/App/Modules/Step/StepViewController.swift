import UIKit

// swiftlint:disable anyobject_protocol
protocol StepViewControllerDelegate: class {
    func viewCotroller(_ viewCotroller: StepViewController, didProvide step: String)
}
// swiftlint:enable anyobject_protocol

class StepViewController: ViewController<StepViewModel>, StepTableProviderDelegate {
    @IBOutlet private weak var tableView: UITableView!

    var tableProvider: StepTableProvider!
    weak var delegate: StepViewControllerDelegate?

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.registerNibForCell(StepTableViewCell.self)
        tableView.dataSource = tableProvider
        tableProvider.delegate = self
    }

    private func setupViewModel() {
        viewModel.step.subscribe(onNext: { [weak self] step in
            self?.proccess(step)
        }).disposed(by: disposeBag)

        viewModel.isDataProvided.subscribe(onNext: { [weak self] isDataProvided in
            self?.process(isDataProvided)
        }).disposed(by: disposeBag)

        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: viewModel.addDidTap)
            .disposed(by: disposeBag)
    }

    private func proccess(_ step: String) {
        delegate?.viewCotroller(self, didProvide: step)
        navigationController?.popViewController(animated: true)
    }

    private func process(_ isDataProvided: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isDataProvided
    }

    // MARK: - StepTableProviderDelegate

    func provider(_ provider: StepTableProvider, didDequeueStepTextField textField: UITextField) {
        textField.rx.text.orEmpty
            .bind(to: viewModel.stepVariable)
            .disposed(by: disposeBag)
    }
}
