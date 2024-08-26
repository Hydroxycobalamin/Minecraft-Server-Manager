import Foundation

class AddWorldHelper {
    func addWorld(version: String, worldPath: String) {
        if !AppDataManager.shared.validVersions.contains(version) {
            print(HelperError.versionError(version: version))
            return
        }

        let worldUrl = URL(fileURLWithPath: sanitizePath(from: worldPath))

        // Check if folder is a minecraft world.
        if !PersistentManager.shared.fileManager.fileExists(atPath: worldUrl.appendingPathComponent("level.dat").path) {
            print(HelperError.invalidWorld(path: worldPath))
            return
        }

        let destinationDirectory = ConfigurationManager.shared.worldDir.appendingPathComponent(version.replacingOccurrences(of: ".", with: ""))
        if PersistentManager.shared.moveItem(from: worldUrl, to: destinationDirectory.appendingPathComponent(worldUrl.lastPathComponent)) != .success {
            return
        }

        if let worlds = AppDataManager.shared.masterData?.worlds,
           worlds.contains(where: {$0.worldPath == worldUrl}) {
            print(HelperError.objectAlreadyExist(objectType: "World", path: worldUrl.lastPathComponent))
            return
        }

        let newWorld = World(version: version, worldPath: worldUrl)

        AppDataManager.shared.addWorldToMasterData(world: newWorld)
    }
}
