import RxSwift

class RecipesViewModel: PageViewModel {
    var categoryIdentifier: String!
    var recipes: Observable<[Recipe]> {
        return recipesVariable.asObservable()
    }

    private let recipesVariable = Variable<[Recipe]>([])
    private let getRecipesUseCase: GetRecipesUseCase

    init(getRecipesUseCase: GetRecipesUseCase) {
        self.getRecipesUseCase = getRecipesUseCase
    }

    func getRecipes() {
        guard canGetMore else {
            return
        }

        if recipesVariable.value.isEmpty {
            state.onNext(.loading)
        }

        getRecipesUseCase.getRecipes(categoryIdentifier: categoryIdentifier,
                                     cursor: cursor,
                                     success: { [weak self] page in
                                        self?.proccess(page)
                                    }, failure: { [weak self] error in
                                        self?.proccess(error)
                                    })
    }

    func refreshRecipes() {
        cursor = nil
        canGetMore = true
        getRecipes()
    }

    // MARK: - Private

    private func proccess(_ page: Page<Recipe>) {
        if cursor == nil && !recipesVariable.value.isEmpty {
            recipesVariable.value.removeAll()
        }

        cursor = page.cursor
        canGetMore = page.cursor != nil
        recipesVariable.value += page.result

        let nextState = recipesVariable.value.isEmpty ? ViewState.empty : ViewState.content
        state.onNext(nextState)
    }

    // MARK: - ViewModel

    override func tryAgain() {
        recipesVariable.value.removeAll()
        refreshRecipes()
    }
}
