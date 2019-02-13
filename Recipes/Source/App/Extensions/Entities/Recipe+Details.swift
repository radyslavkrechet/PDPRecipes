import Foundation

extension Recipe {
    var ingredientsDetails: String {
        return ingredients.enumerated().reduce(String()) { result, nextIngredient  in
            let (offset, element) = nextIngredient
            let nextLine = ingredients.count - 1 > offset ? "\n" : String()
            return result + element.details + nextLine
        }
    }
    var stepsDetails: String {
        return steps.enumerated().reduce(String()) { result, nextStep  in
            let (offset, element) = nextStep
            let nextLine = steps.count - 1 > offset ? "\n" : String()
            return result + "\(offset + 1). \(element)" + nextLine
        }
    }
}
