import Foundation

class Plugin: Codable {
    let id: UUID
    let name: String
    var build: Int?
    var path: URL?
    let origin: OriginType

    init(name: String, build: Int? = nil, path: URL? = nil, origin: OriginType) {
        self.id = UUID()
        self.name = name
        self.build = build
        self.path = path
        self.origin = origin
    }
}


