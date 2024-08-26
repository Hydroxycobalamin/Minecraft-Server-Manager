import Foundation

enum HelperError: Error {
    case versionError(version: String)
    case pathNotExistError(path: String)
    case objectAlreadyExist(objectType: String, path: String)
    case urlInvalidCharacters(path: String)
    case invalidOrigin(origin: String)
    case invalidWorld(path: String)
}

extension HelperError: CustomStringConvertible {
    var description: String {
        switch self {
        case .versionError(let version):
            return "Version '\(version)' is not supported. Supported versions are \(AppDataManager.shared.validVersions)"
        case .pathNotExistError(let path):
            return "Path '\(path)' does not exist."
        case .objectAlreadyExist(let objectType, let path):
            return "'\(objectType)' was already added on path '\(path)'."
        case .urlInvalidCharacters(let path):
            return "Path: '\(path)' contains invalid characters."
        case .invalidOrigin(let origin):
            return "Origin: '\(origin)' is not valid."
        case .invalidWorld(let path):
            return "'level.dat' could not be found. Are you sure '\(path)' is a valid world?"
        }
    }
}

