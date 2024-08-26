import Foundation

class AddPluginHelper {
    /// Adds a plugin to the Manager and saves it.
    /// - Parameters:
    ///   - name: Name of the plugin.
    ///   - origin: Type of the website, ie: jenkins
    func addPlugin(as name: String, from origin: String) {
        if let plugins = AppDataManager.shared.masterData?.plugins,
           plugins.contains(where: { $0.name == name }) {
            // TODO: ErrorHandling
            return
        }

        guard let origin = OriginType(rawValue: origin) else {
            print(HelperError.invalidOrigin(origin: origin))
            return
        }

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

        let jarFileName = jarFilePath.lastPathComponent
        let pluginDestination = ConfigurationManager.shared.pluginDir.appendingPathComponent(jarFileName)
        let moveResult = PersistentManager.shared.moveItem(
            from: jarFilePath,
            to: pluginDestination
        )
        if moveResult != .success {
            // TODO: ErrorHandling
            return
        }


        guard let pluginBuildNumber = extractBuildNumber(from: jarFileName) else {
            // TODO: ErrorHandling
            return
        }
        newPlugin.build = pluginBuildNumber
        newPlugin.path = pluginDestination


        AppDataManager.shared.addPluginToMasterData(plugin: newPlugin)
    }
}
