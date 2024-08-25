import Foundation

class SymlinkHelper {
    func addPluginToServer(serverName: String, pluginName: String) {
        guard let plugin = AppDataManager.shared.getPluginFromMasterData(pluginName: pluginName) else {
            print("0")
            return
        }
        guard var server = AppDataManager.shared.getServerFromMasterData(serverName: serverName) else {
            print("1")
            return
        }
        // Already exists
        if !server.symPlugins.isEmpty {
            guard let symLink = server.symPlugins.first(where: { $0.fromUrl == plugin.path }) else {
                print("2")
                return
            }
        }
        // PluginPath not exist.
        guard let pluginPath = plugin.path else {
            print("3")
            return
        }
        let serverPluginPath = server.serverPath.appendingPathComponent("plugins/\(pluginPath.lastPathComponent)")

        // Create symLink
        do {
            try PersistentManager.shared.fileManager.linkItem(at: pluginPath, to: serverPluginPath)
            let newSymlink = Symlink(fromUrl: pluginPath, toUrl: serverPluginPath, serverID: server.id, pluginID: plugin.id)
            server.symPlugins.append(newSymlink)
            print("4")
        }
        catch {
            print("5" + error.localizedDescription)
            return

        }

        PersistentManager.shared.saveJson()
    }
}
