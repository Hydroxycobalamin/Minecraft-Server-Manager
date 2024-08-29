import Foundation

enum OptionType: String, CaseIterable {
    case update
    case addserver
    case addplugin
    case addworld
    case addplugintoserver
    case addworldtoserver

    func getDescription(for job: OptionType) -> String {
        switch self {
        case .update:
            return "Type 'update' to update."
        case .addserver:
            return "Type 'addserver' to add a server."
        case .addplugin:
            return "Type 'addplugin' to add a plugin."
        case .addworld:
            return "Type 'addworld' to add a world."
        case .addplugintoserver:
            return "Type 'addplugintoserver' to add a plugin to a server."
        case .addworldtoserver:
            return "Type 'addworldtoserver' to add worlds to a server."
        }
    }
}
