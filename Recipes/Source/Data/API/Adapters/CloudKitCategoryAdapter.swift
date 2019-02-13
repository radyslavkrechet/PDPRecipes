import CloudKit

private let nameKey = "name"
private let iconKey = "icon"

struct CloudKitCategoryAdapter {
    static func adapt(_ record: CKRecord) -> Category {
        let name = record[nameKey] as? String ?? String()
        let createdDate = record.creationDate ?? Date()

        var icon = Data()
        if let url = (record[iconKey] as? CKAsset)?.fileURL, let data = try? Data(contentsOf: url) {
            icon = data
        }

        return Category(identifier: record.recordID.recordName, name: name, icon: icon, createdDate: createdDate)
    }
}
