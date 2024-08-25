import Foundation

class UpdateHelper {
    func updateToLatest() {
        guard let plugins = AppDataManager.shared.masterData?.plugins else {
            return
        }
        guard let servers = AppDataManager.shared.masterData?.servers else {
            return
        }
        for plugin in plugins {
            let name = plugin.name
            let origin = plugin.origin
            var newPlugin = Plugin(name: name, build: nil, path: nil, origin: origin)
            guard let downloadUrl = origin.getUrl(for: newPlugin) else {
                // TODO: ErrorHandling
                return
            }
            let downloadResult = APIHelper().download(from: origin, with: downloadUrl, pluginName: name)
            if downloadResult != .success {
                // TODO: ErrorHandling
                return
            }
            let unzipResult = PersistentManager.shared.unzipFile(to: name)
            if unzipResult != .success {
                // TODO: ErrorHandling
                return
            }
            guard let jarFilePath = PersistentManager.shared.findJarFiles(
                in: ConfigurationManager.shared.downloadDir.appendingPathComponent(name)
            ) else {
                // TODO: ErrorHandling
                return
            }
            guard let pluginPath = plugin.path else {
                return
            }
            do {
                try PersistentManager.shared.fileManager.removeItem(at: pluginPath)
            } catch {
                return
            }

        //    for server in servers {
       //         if server.symPlugins.contains(where: { $0.})
        //    }
        }
    }
}
