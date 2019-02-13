import RxSwift

class ViewModel {
    let state = PublishSubject<ViewState>()

    // MARK: - Setup

    func proccess(_ error: RecipesError) {
        state.onNext(.error(error))
    }

    // MARK: - Methods to override

    func tryAgain() {
        assert(false, "tryAgain() has not been implemented")
    }
}
