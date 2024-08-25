import Foundation

class AddServerHelper {
    /// Adds a server to the Manager and saves it.
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
            print("Not enough worlds to symlink. Make sure you put linked default worlds: world, world_nether and world_the_end.")
            return
        }
        if !PersistentManager.shared.fileManager.fileExists(atPath: path) {
            print(HelperError.pathNotExistError(path: path))
            return
        }
        let serverUrl = URL(fileURLWithPath: path)
        /*
            print(HelperError.urlInvalidCharacters(path: path))
            return
        }*/

        guard let servers = AppDataManager.shared.masterData?.servers,
           servers.contains(where: { $0.serverPath == serverUrl }) else {
            print(HelperError.objectAlreadyExist(objectType: "Server", path: path))
            return
        }

        var newServer = Server(name: name, currentVersion: version, symWorlds: [], symPlugins: [], serverPath: serverUrl)
        // TODO: Create Worlds in /Master/worlds and add SymlinkHelper.

        

        AppDataManager.shared.addServerToMasterData(server: newServer)
    }
}
