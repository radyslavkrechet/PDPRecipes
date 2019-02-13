import RxCocoa
import RxSwift

enum ViewState {
    case loading
    case empty
    case content
    case error(_ error: RecipesError)
}

class ViewController<T: ViewModel>: UIViewController, ErrorViewDelegate {
    let disposeBag = DisposeBag()
    var viewModel: T!
    var emptyStateMessage: String {
        return String()
    }

    private let loadingView = LoadingView()
    private let emptyView = EmptyView()
    private let errorView = ErrorView()

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }

    // MARK: - Setup

    private func setupViews() {
        errorView.delegate = self
    }

    private func setupViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            self?.proccess(state)
        }).disposed(by: disposeBag)
    }

    private func proccess(_ state: ViewState) {
        switch state {
        case .loading:
            errorView.removeFromSuperview()
            add(loadingView)
        case .empty:
            loadingView.removeFromSuperview()
            emptyView.populate(with: emptyStateMessage)
            add(emptyView)
        case .content:
            loadingView.removeFromSuperview()
        case .error(let error):
            loadingView.removeFromSuperview()
            errorView.populate(with: error)
            add(errorView)
        }
    }

    private func add(_ subview: UIView) {
        view.addSubview(subview)
        view.addConstraints(to: subview)
    }

    // MARK: - ErrorViewDelegate

    func viewDidTapTryAgain(_ view: ErrorView) {
        viewModel.tryAgain()
    }
}
