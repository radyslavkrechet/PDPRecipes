import RxSwift

class CategoriesViewModel: ViewModel {
    var categories: Observable<[Category]> {
        return categoriesSubject.asObservable()
    }

    private let categoriesSubject = PublishSubject<[Category]>()
    private let getCategoriesUseCase: GetCategoriesUseCase

    init(getCategoriesUseCase: GetCategoriesUseCase) {
        self.getCategoriesUseCase = getCategoriesUseCase
    }

    func getCategories() {
        getCategoriesUseCase.getCategories(success: { [weak self] categories in
            self?.proccess(categories)
        }, failure: { [weak self] error in
            self?.proccess(error)
        })
    }

    // MARK: - Private

    private func proccess(_ categories: [Category]) {
        categoriesSubject.onNext(categories)
    }

    // MARK: - ViewModel

    override func tryAgain() {
        getCategories()
    }
}
