import UIKit

private let space: CGFloat = 20
private let ratio: CGFloat = 1.2

// swiftlint:disable anyobject_protocol
protocol RecipesCollectionProviderDelegate: class {
    var collectionView: UICollectionView! { get }

    func provider(_ provider: RecipesCollectionProvider, didSelectRecipeWithIdentifier identifier: String)
    func providerWillDisplayLastRecipe(_ provider: RecipesCollectionProvider)
}
// swiftlint:enable anyobject_protocol

class RecipesCollectionProvider: NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {

    weak var delegate: RecipesCollectionProviderDelegate?

    private var recipes = [Recipe]()

    func set(_ recipes: [Recipe]) {
        self.recipes = recipes
        delegate?.collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let recipe = recipes[indexPath.row]
        let cell: RecipeCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
        cell.populate(with: recipe)
        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let recipe = recipes[indexPath.row]
        delegate?.provider(self, didSelectRecipeWithIdentifier: recipe.identifier)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        if indexPath.item == recipes.count - 1 {
            delegate?.providerWillDisplayLastRecipe(self)
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widthOfContent = delegate?.collectionView.bounds.size.width ?? UIScreen.main.bounds.size.width
        let numberOfColumns: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
        let spacing = (numberOfColumns + 1) * space
        let width = (widthOfContent - spacing) / numberOfColumns
        let height = Float(width * ratio)
        let roundedHeight = CGFloat(lroundf(height))
        return CGSize(width: width, height: roundedHeight)
    }
}
