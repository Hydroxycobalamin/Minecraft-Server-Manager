import Foundation

class Server: Codable {
    let id: UUID
    let name: String
    let currentVersion: String
    var symWorlds: [Symlink]
    var symPlugins: [Symlink]
    let serverPath: URL

    init(name: String, currentVersion: String, symWorlds: [Symlink], symPlugins: [Symlink], serverPath: URL) {
        self.id = UUID()
        self.name = name
        self.currentVersion = currentVersion
        self.symWorlds = symWorlds
        self.symPlugins = symPlugins
        self.serverPath = serverPath
    }
}
