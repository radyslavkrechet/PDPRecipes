import RxSwift

class PreloadViewModel: ViewModel {
    var accountStatus: Observable<Bool> {
        return accountStatusSubject.asObservable()
    }
    var didGetData: Observable<Void> {
        return Observable.combineLatest(categoriesSubject, ingredientUnitsSubject) { _, _ in
            ()
        }
    }

    private let accountStatusSubject = PublishSubject<Bool>()
    private let categoriesSubject = PublishSubject<[Category]>()
    private let ingredientUnitsSubject = PublishSubject<[IngredientUnit]>()
    private let getAccountStatusUseCase: GetAccountStatusUseCase
    private let getCategoriesUseCase: GetCategoriesUseCase
    private let getIngredientUnitsUseCase: GetIngredientUnitsUseCase

    init(getAccountStatusUseCase: GetAccountStatusUseCase,
         getCategoriesUseCase: GetCategoriesUseCase,
         getIngredientUnitsUseCase: GetIngredientUnitsUseCase) {

        self.getAccountStatusUseCase = getAccountStatusUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getIngredientUnitsUseCase = getIngredientUnitsUseCase
    }

    func getAccountStatus() {
        getAccountStatusUseCase.getAccountStatus(success: { [weak self] _ in
            self?.proccess(true)
        }, failure: { [weak self] _ in
            self?.proccess(false)
        })
    }

    func getCategories() {
        getCategoriesUseCase.getCategories(success: { [weak self] categories in
            self?.proccess(categories)
        }, failure: { [weak self] error in
            self?.proccess(error)
        })
    }

    func getIngredientUnits() {
        getIngredientUnitsUseCase.getIngredientUnits(success: { [weak self] ingredientUnits in
            self?.proccess(ingredientUnits)
        }, failure: { [weak self] error in
            self?.proccess(error)
        })
    }

    // MARK: - Private

    private func proccess(_ accountStatus: Bool) {
        accountStatusSubject.onNext(accountStatus)
    }

    private func proccess(_ categories: [Category]) {
        categoriesSubject.onNext(categories)
    }

    private func proccess(_ ingredientUnits: [IngredientUnit]) {
        ingredientUnitsSubject.onNext(ingredientUnits)
    }

    // MARK: - ViewModel

    override func tryAgain() {
        getCategories()
        getIngredientUnits()
    }
}
