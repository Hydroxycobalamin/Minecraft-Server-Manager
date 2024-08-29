import Foundation

class SymlinkHelper {
    func addPluginToServer(serverName: String, pluginName: String) {
        // Check if plugin exists.
        guard let plugin = AppDataManager.shared.getPluginFromMasterData(pluginName: pluginName) else {
            print(HelperError.objectDoesNotExist(objectType: "Plugin", name: pluginName))
            return
        }
        // Check if server exists.
        guard let server = AppDataManager.shared.getServerFromMasterData(serverName: serverName) else {
            print(HelperError.objectDoesNotExist(objectType: "Server", name: serverName))
            return
        }
        // Check if plugin is already linked to the server.
        if !server.symPlugins.isEmpty, let symLink = server.symPlugins.first(where: { $0.fromUrl == plugin.path }) {
            print(HelperError.objectAlreadyExist(objectType: "World", path: symLink.toUrl.path))
            return
        }
        // Check if the plugin has a path.
        guard let pluginPath = plugin.path else {
            print(HelperError.objectNoPath(objectType: "Plugin", name: pluginName))
            return
        }

        // Create the Hardlink.
        let serverPluginPath = server.serverPath.appendingPathComponent("plugins/\(pluginPath.lastPathComponent)")
        do {
            try PersistentManager.shared.fileManager.linkItem(at: pluginPath, to: serverPluginPath)
            let newSymlink = Symlink(
                fromUrl: pluginPath, toUrl: serverPluginPath, serverID: server.id, objectID: plugin.id
            )
            server.symPlugins.append(newSymlink)
        } catch {
            print("Error while creating Hardlink.\n\(error.localizedDescription)")
            return
        }

        PersistentManager.shared.saveJson()
    }

    func addWorldToServer(serverName: String, version: String) {
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
        // Check if server exists.
        guard let server = AppDataManager.shared.getServerFromMasterData(serverName: serverName) else {
            print(HelperError.objectDoesNotExist(objectType: "Server", name: serverName))
            return
        }
        // Check if worlds are already linked to the server.
        if !server.symWorlds.isEmpty {
            print(HelperError.serverHasWorldsSymlinked(name: serverName))
            return
        }

        do {
            for world in worlds {
                let source = server.serverPath.appendingPathComponent(world.worldPath.lastPathComponent)
                try PersistentManager.shared.fileManager.createSymbolicLink(at: source, withDestinationURL: world.worldPath)
                let newSymlink = Symlink(
                    fromUrl: world.worldPath, toUrl: source, serverID: server.id, objectID: world.id
                )
                server.symWorlds.append(newSymlink)
                print(source)
                print(world.worldPath)
            }
        } catch {
            print("Error while creating Symlink\n\(error.localizedDescription)")
        }

        PersistentManager.shared.saveJson()
    }
}
