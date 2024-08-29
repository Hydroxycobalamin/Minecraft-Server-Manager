import Foundation

class AddWorldHelper {
    // TODO: HELLO
    func addWorld(version: String, worldPath: String) {
        // Check if world version is valid.
        if !AppDataManager.shared.validVersions.contains(version) {
            print(HelperError.versionError(version: version))
            return
        }
        // Sanitize Path because of lazy macOS.
        let worldUrl = URL(fileURLWithPath: sanitizePath(from: worldPath))
        // Check if folder is a minecraft world.
        if !PersistentManager.shared.fileManager.fileExists(atPath: worldUrl.appendingPathComponent("level.dat").path) {
            print(HelperError.invalidWorld(path: worldPath))
            return
        }
        // Moving the world to the Master/worlds folder.
        let destinationDirectory = ConfigurationManager.shared.worldDir.appendingPathComponent(version.replacingOccurrences(of: ".", with: ""))
        let finalDestination = destinationDirectory.appendingPathComponent(worldUrl.lastPathComponent)
        if PersistentManager.shared.moveItem(from: worldUrl, to: finalDestination) != .success {
            // Error is handled in the method.
            return
        }

        let newWorld = World(version: version, worldPath: finalDestination)
        AppDataManager.shared.addWorldToMasterData(world: newWorld)
    }
}
