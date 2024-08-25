import Foundation

enum FileManagerError : Error {
    case zipUnpackError(message: String = "Error while unzipping the file")
    case zipCallError(message: String)
    case downloadError(message: String)
}
