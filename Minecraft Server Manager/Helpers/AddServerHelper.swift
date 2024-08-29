import Foundation

class AddServerHelper {
    /// Adds a server to the Manager and saves it. Requires to have added 3 default worlds first.
    /// - Parameters:
    ///   - name: Name of the server.
    ///   - version: Version of the server.
    ///   - path: FilePath of the server.
    func addServer(as name: String, with version: String, on path: String) {
        if !AppDataManager.shared.validVersions.contains(version) {
            print(HelperError.versionError(version: version))
            return
        }
        guard let worlds = AppDataManager.shared.getWorldsFromMasterData(version: version) else {
            print("No worlds have been found")
            return
        }
        if worlds.count != 3 {
            print("Not enough worlds to symlink. Make sure you linked default worlds: world, world_nether and world_the_end.")
            return
        }
        let serverUrl = URL(fileURLWithPath: sanitizePath(from: path))
        if !PersistentManager.shared.fileManager.fileExists(atPath: serverUrl.path) {
            print(HelperError.pathNotExistError(path: serverUrl.path))
            return
        }

        if AppDataManager.shared.getServerFromMasterData(serverPath: serverUrl.path) != nil {
            print(HelperError.objectAlreadyExist(objectType: "Server", path: serverUrl.path))
        }

        var newServer = Server(name: name, currentVersion: version, symWorlds: [], symPlugins: [], serverPath: serverUrl)

        AppDataManager.shared.addServerToMasterData(server: newServer)
    }
}
