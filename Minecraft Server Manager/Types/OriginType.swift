import Foundation

enum OriginType: String, Codable {
    case jenkins

    func getUrl(for plugin: Plugin) -> URL? {
        switch self {
        case .jenkins:
            return URL(string: "https://ci.citizensnpcs.co/job/\(plugin.name)/lastSuccessfulBuild/artifact/*zip*/archive.zip")
        }
    }
}
