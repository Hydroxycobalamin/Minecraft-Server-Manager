import Foundation

struct World: Codable {
    let id: UUID
    let version: String
    let worldPath: URL

    init(version: String, worldPath: URL) {
        self.id = UUID()
        self.version = version
        self.worldPath = worldPath
    }
}
