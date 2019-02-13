import Foundation

struct Category {
    let identifier: String
    let name: String
    let icon: Data
    let createdDate: Date

    init(identifier: String, name: String, icon: Data, createdDate: Date) {
        self.identifier = identifier
        self.name = name
        self.icon = icon
        self.createdDate = createdDate
    }
}
