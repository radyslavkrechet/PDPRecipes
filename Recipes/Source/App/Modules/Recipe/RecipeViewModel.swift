import RxSwift

class RecipeViewModel: ViewModel {
    var recipe: Observable<Recipe> {
        return recipeSubject.asObservable()
    }
    var didDeleteRecipe: Observable<Void> {
        return recipeDeletingSubject.asObservable()
    }

    private let recipeSubject = PublishSubject<Recipe>()
    private let recipeDeletingSubject = PublishSubject<Void>()
    private let getRecipeUseCase: GetRecipeUseCase
    private let deleteRecipeUseCase: DeleteRecipeUseCase
    private var recipeIngredient: String!

    init(getRecipeUseCase: GetRecipeUseCase, deleteRecipeUseCase: DeleteRecipeUseCase) {
        self.getRecipeUseCase = getRecipeUseCase
        self.deleteRecipeUseCase = deleteRecipeUseCase
    }

    func getRecipe(identifier: String) {
        recipeIngredient = identifier
        state.onNext(.loading)

        getRecipeUseCase.getRecipe(identifier: identifier, success: { [weak self] recipe in
            self?.proccess(recipe)
        }, failure: { [weak self] error in
            self?.proccess(error)
        })
    }

    func deleteRecipe() {
        state.onNext(.loading)

        deleteRecipeUseCase.deleteRecipe(identifier: recipeIngredient, success: { [weak self] _ in
            self?.proccessRecipeDeleting()
        }, failure: { [weak self] error in
            self?.proccess(error)
        })
    }

    // MARK: - Private

    private func proccess(_ recipe: Recipe) {
        recipeSubject.onNext(recipe)
        state.onNext(.content)
    }

    private func proccessRecipeDeleting() {
        recipeDeletingSubject.onNext(())
    }

    // MARK: - ViewModel

    override func tryAgain() {
        getRecipe(identifier: recipeIngredient)
    }
}
