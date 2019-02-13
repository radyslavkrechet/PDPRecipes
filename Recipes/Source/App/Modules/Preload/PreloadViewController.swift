import UIKit

class PreloadViewController: ViewController<PreloadViewModel> {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        getAccountStatus()
    }

    // MARK: - Setup

    private func setupViewModel() {
        viewModel.accountStatus.subscribe(onNext: { [weak self] accountStatus in
            self?.proccess(accountStatus)
        }).disposed(by: disposeBag)

        viewModel.didGetData.subscribe(onNext: { [weak self] _ in
            self?.proccessDataGetting()
        }).disposed(by: disposeBag)
    }

    private func getAccountStatus() {
        viewModel.getAccountStatus()
    }

    private func getData() {
        activityIndicator.startAnimating()
        viewModel.getCategories()
        viewModel.getIngredientUnits()
    }

    private func proccess(_ accountStatus: Bool) {
        accountStatus ? getData() : presentAlert()
    }

    private func proccessDataGetting() {
        performSegue(withIdentifier: SegueIdentifiers.toApplication, sender: self)
    }

    private func presentAlert() {
        let settingsActionHandler: (UIAlertAction) -> Void = { _ in
            self.openSettingsApplication()
        }
        let settingsAction = UIAlertAction(title: "preloadViewController.alert.settings".localized(),
                                           style: .default,
                                           handler: settingsActionHandler)

        let okAction = UIAlertAction(title: "preloadViewController.alert.ok".localized(), style: .default)
        let alertViewController = UIAlertController(title: "preloadViewController.alert.title".localized(),
                                                    message: "preloadViewController.alert.message".localized(),
                                                    preferredStyle: .alert)

        alertViewController.addAction(settingsAction)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true)
    }

    private func openSettingsApplication() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
