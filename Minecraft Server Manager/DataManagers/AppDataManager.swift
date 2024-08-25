import Foundation

final class AppDataManager {
    static let shared = AppDataManager()

    let validVersions = ["1.17.1", "1.18.2", "1.19.4", "1.20.6"]
    var masterData: MasterData? = nil {
        didSet {
            PersistentManager.shared.saveJson()
        }
    }

    func loadData() {
        guard let jsonData = PersistentManager.shared.loadJson(filePath: ConfigurationManager.shared.dataFile) else {
            masterData = MasterData(servers: [], plugins: [], worlds: [])
            return
        }

        let decoder = JSONDecoder()
        do {
            masterData = try decoder.decode(MasterData.self, from: jsonData)
        } catch {
            print("Error while decoding the file. Is the file a valid json?\n" + error.localizedDescription)
            masterData = MasterData(servers: [], plugins: [], worlds: [])
        }

    }

    func addPluginToMasterData(plugin: Plugin) {
        masterData?.plugins.append(plugin)
    }

    func addServerToMasterData(server: Server) {
        masterData?.servers.append(server)
    }

    func addWorldToMasterData(world: World) {
        masterData?.worlds.append(world)
    }

    func getPluginFromMasterData(pluginName: String) -> Plugin? {
        return masterData?.plugins.first(where: { $0.name == pluginName })
    }

    func getServerFromMasterData(serverName: String) -> Server? {
        return masterData?.servers.first(where: { $0.name == serverName })
    }

    func getWorldsFromMasterData(version: String) -> [World]? {
        return masterData?.worlds.filter({ $0.version == version})
    }
}
