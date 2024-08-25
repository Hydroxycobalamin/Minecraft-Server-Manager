import Foundation

class AddWorldHelper {
    func addWorld(version: String, worldPath: String) {
        if !AppDataManager.shared.validVersions.contains(version) {
            print(HelperError.versionError(version: version))
            return
        }

        guard let worldUrl = URL(string: worldPath) else {
            print("Could not create filePath from provided path:\(worldPath)")
            return
        }
        
        if !PersistentManager.shared.fileManager.fileExists(atPath: worldUrl.appendingPathComponent("level.dat").path) {
            // TODO: ErrorHandling
            return
        }

        if let worlds = AppDataManager.shared.masterData?.worlds,
           worlds.contains(where: {$0.worldPath == worldUrl}) {
            print("This world was already added.")
            return
        }

        let newWorld = World(version: version, worldPath: worldUrl)

        AppDataManager.shared.addWorldToMasterData(world: newWorld)
    }
}
