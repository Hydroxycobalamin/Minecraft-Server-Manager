import Foundation

final class ConfigurationManager {
    static let shared = ConfigurationManager()

    let workingFolder = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
    lazy var downloadDir = workingFolder.appendingPathComponent("downloads")
    lazy var dataFile = workingFolder.appendingPathComponent("data/data.json")
    lazy var worldDir = workingFolder.appendingPathComponent("worlds")
    lazy var pluginDir = workingFolder.appendingPathComponent("plugins")
}
