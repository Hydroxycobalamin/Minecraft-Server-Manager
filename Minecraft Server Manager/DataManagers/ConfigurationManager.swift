import Foundation

final class ConfigurationManager {
    static let shared = ConfigurationManager()

    let workingFolder = URL(fileURLWithPath: PersistentManager.shared.fileManager.currentDirectoryPath)
    lazy var downloadDir = workingFolder.appendingPathComponent("downloads")
    lazy var dataFile = workingFolder.appendingPathComponent("data/data.json")
}
