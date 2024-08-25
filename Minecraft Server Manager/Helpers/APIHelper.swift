import Foundation

class APIHelper {

    func download(from origin: OriginType, with url: URL, pluginName: String) -> DownloadResult {
        switch origin {
        case .jenkins:
            return downloadFromJenkins(with: url, pluginName)
        }
    }

    func downloadFromJenkins(with url: URL, _ pluginName: String) -> DownloadResult {
        do {
            let data = try Data(contentsOf: url)
            try data.write(to: ConfigurationManager.shared.downloadDir.appendingPathComponent("archive.zip"))
            print("Herunterladen von \(pluginName) erfolgreich.")
            return .success
        } catch {
            print(error.localizedDescription)
            return .failedFetching
        }
    }

}
