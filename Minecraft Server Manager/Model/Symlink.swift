import Foundation

struct Symlink: Codable {
    let fromUrl: URL
    let toUrl: URL
    let serverID: UUID
    let pluginID: UUID
}
