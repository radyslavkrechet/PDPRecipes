<h1><img src="https://github.com/radyslavkrechet/PDPRecipes/blob/master/Recipes/Resources/Assets/Assets.xcassets/AppIcon.appiconset/180.png" width="23" height="23">Recipes</h1>

<p float="left">
  <img src="/Screenshots/1.png" width="200px" />
  <img src="/Screenshots/2.png" width="200px" />
  <img src="/Screenshots/3.png" width="200px" />
  <img src="/Screenshots/4.png" width="200px" />
</p>

### Clean architecture application that used: ###

* RxSwift for bind View with View Model
* CloudKit for CRUD operations with recipes
* CoreStore pod for work with CoreData database
* Swinject pod for injection of dependencies
* SwiftLint pod for tooling of style and conventions

### Setup the application before run: ###

* Create a container in ```CloudKit Dashboard```
* Create custom record types with indexes
![Category](/Resources/1.png)
![Ingredient](/Resources/2.png)
![IngredientUnit](/Resources/3.png)
![Recipe](/Resources/4.png)
* Create ```categories``` with names ```soup```, ```main-dish```, ```side-dish```, ```bread```, ```salad```, ```appetizer```, ```sauce```, ```dessert```, ```drink``` in ```Public Database```
* Create ```ingredient units``` with names ```ml```, ```g```, ```pc```, ```kg```, ```tbsp```, ```tsp``` and ```l``` in ```Public Database``` 
