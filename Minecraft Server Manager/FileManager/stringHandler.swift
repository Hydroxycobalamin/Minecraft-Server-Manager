import Foundation

func extractPluginName(from filename: String) -> String? {
    guard let range = filename.range(of: "-") else {
        return nil
    }
    return String(filename[..<range.lowerBound])
}

func extractBuildNumber(from filename: String) -> Int? {
    let parts = filename.split(separator: "-")
    print(filename)
    for part in parts {
        if part.hasPrefix("b") {
            let buildNumber = Int(part.dropFirst().prefix(while: { $0.isNumber }))
            return buildNumber
        }
    }
    return nil
}

func sanitizePath(from path: String) -> String {
    return path.replacingOccurrences(of: "\\ ", with: " ")
}
