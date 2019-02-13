import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: String())
    }

    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }
}
