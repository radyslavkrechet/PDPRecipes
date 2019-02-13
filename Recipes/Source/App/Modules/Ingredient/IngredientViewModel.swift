import RxSwift

class IngredientViewModel: ViewModel {
    let nameVariable = Variable<String>(String())
    let numberVariable = Variable<String>(String())
    let indexOfSelectedIngredientUnitVariable = Variable<Int?>(nil)
    var ingredientUnits: Observable<[IngredientUnit]> {
        return ingredientUnitsVariable.asObservable()
    }
    var ingredient: Observable<Ingredient> {
        return ingredientVariable.asObservable()
    }
    var isDataProvided: Observable<Bool> {
        let name = nameVariable.asObservable()
        let number = numberVariable.asObservable()
        let index = indexOfSelectedIngredientUnitVariable.asObservable()
        return Observable.combineLatest(name, number, index) { name, number, index in
            return !name.isEmpty && !number.isEmpty && index != nil
        }
    }
    var addDidTap: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                self?.addIngredient()
            default:
                break
            }
        }
    }

    private let ingredientUnitsVariable = Variable<[IngredientUnit]>([])
    private let ingredientVariable = PublishSubject<Ingredient>()
    private let getIngredientUnitsUseCase: GetIngredientUnitsUseCase

    init(getIngredientUnitsUseCase: GetIngredientUnitsUseCase) {
        self.getIngredientUnitsUseCase = getIngredientUnitsUseCase
    }

    func getIngredientUnits() {
        state.onNext(.loading)

        getIngredientUnitsUseCase.getIngredientUnits(success: { [weak self] ingredientUnits in
            self?.proccess(ingredientUnits)
        }, failure: { [weak self] error in
            self?.proccess(error)
        })
    }

    // MARK: - Private

    private func proccess(_ ingredientUnits: [IngredientUnit]) {
        ingredientUnitsVariable.value = ingredientUnits
        state.onNext(.content)
    }

    private func addIngredient() {
        let identifier = String()
        let date = Date()
        let number = Int(numberVariable.value) ?? Int()
        let index = indexOfSelectedIngredientUnitVariable.value ?? Int()
        let unit = ingredientUnitsVariable.value[index]
        let ingredient = Ingredient(identifier: identifier,
                                    name: nameVariable.value,
                                    number: number,
                                    unit: unit,
                                    createdDate: date)

        ingredientVariable.onNext(ingredient)
    }

    // MARK: - ViewModel

    override func tryAgain() {
        getIngredientUnits()
    }
}
