import RxSwift

class RecipeFormViewModel: ViewModel {
    let photoVariable = Variable<URL?>(nil)
    let nameVariable = Variable<String>(String())
    let noteVariable = Variable<String>(String())
    let ingredientsVariable = Variable<[Ingredient]>([])
    let stepsVariable = Variable<[String]>([])
    var categoryIdentifier: String!
    var didCreateRecipe: Observable<Void> {
        return recipeCreatingSubject.asObservable()
    }
    var isDataProvided: Observable<Bool> {
        let url = photoVariable.asObservable()
        let name = nameVariable.asObservable()
        let note = noteVariable.asObservable()
        let ingredients = ingredientsVariable.asObservable()
        let steps = stepsVariable.asObservable()
        return Observable.combineLatest(url, name, note, ingredients, steps) { url, name, note, ingredients, steps in
            return url != nil && !name.isEmpty && !note.isEmpty && !ingredients.isEmpty && !steps.isEmpty
        }
    }
    var doneDidTap: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                self?.createRecipe()
            default:
                break
            }
        }
    }

    private let recipeCreatingSubject = PublishSubject<Void>()
    private let createRecipeUseCase: CreateRecipeUseCase

    init(createRecipeUseCase: CreateRecipeUseCase) {
        self.createRecipeUseCase = createRecipeUseCase
    }

    // MARK: - Private

    private func createRecipe() {
        let identifier = String()
        let date = Date()
        let recipe = Recipe(identifier: identifier,
                            name: nameVariable.value,
                            note: noteVariable.value,
                            photo: photoVariable.value,
                            ingredients: ingredientsVariable.value,
                            steps: stepsVariable.value,
                            categoryIdentifier: categoryIdentifier,
                            createdDate: date)

        state.onNext(.loading)

        createRecipeUseCase.createRecipe(recipe: recipe, success: { [weak self] _ in
            self?.proccessRecipeCreating()
        }, failure: { [weak self] error in
            self?.proccess(error)
        })
    }

    private func proccessRecipeCreating() {
        recipeCreatingSubject.onNext(())
    }

    // MARK: - ViewModel

    override func tryAgain() {
        createRecipe()
    }
}
