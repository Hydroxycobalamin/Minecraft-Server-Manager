import Foundation

/// Macht alle IO Zugriffe. Der und nur der! Keine andere Klasse.
/// - Important: NUR DER!!!!!
final class PersistentManager {
    static let shared = PersistentManager()
    let fileManager = FileManager.default

    func saveJson() {
        guard let jsonData = AppDataManager.shared.masterData?.getJsonData else {
            print("Error while saving jsonData.")
            return
        }
        do {
            try jsonData.write(to: ConfigurationManager.shared.dataFile, options: .atomic)
            print("Jsondata saved")
        } catch {
            print("Error writing json data\n\(error.localizedDescription)")
        }
    }

    func loadJson(filePath: URL) -> Data? {
        if !fileManager.fileExists(atPath: filePath.path) {
            return nil
        }
        do {
            return try Data(contentsOf: filePath, options: .mappedIfSafe)
        } catch {
            print("JSON File could not be read.")
            return nil
        }
    }

    /// Entpacken eines ZIP-Archivs
    func unzipFile(to name: String) -> ZipResult {
        do {
            let process = try Process.run(
                URL(fileURLWithPath: "/usr/bin/unzip"),
                arguments: ["-o", ConfigurationManager.shared.downloadDir.appendingPathComponent("archive.zip").path, 
                            "-d", ConfigurationManager.shared.downloadDir.appendingPathComponent(name).path]
            )
            process.waitUntilExit()
            if process.terminationStatus != 0 {
                print(FileManagerError.zipUnpackError())
                return .failed
            }
            return .success
        } catch {
            print(FileManagerError.zipCallError)
            return .failed
        }
    }

    /// Search .jar in directory
    func findJarFiles(in directory: URL) -> URL? {
        let dirEnum = fileManager.enumerator(at: directory, includingPropertiesForKeys: nil)
        let jarFile: URL? = {
            while let file = dirEnum?.nextObject() as? URL {
                if file.pathExtension == "jar" {
                    return file
                }
            }
            return nil
        }()
        return jarFile
    }

    func moveItem(from sourcePath: URL, to destinationPath: URL) -> MoveResult {
        // Checks if the file exists on the destination.
        if fileManager.fileExists(atPath: destinationPath.path) {
            print("File already exists. Can not copy to destination: \(destinationPath)")
            return .failed
        }
        // Checks if the folder structure exists, otherwise it will create it.
        var destinationPathFolder = deleteLastPathComponent(from: destinationPath)
        if !fileManager.fileExists(atPath: destinationPathFolder.path) {
            let status = createFolderPath(at: destinationPathFolder)
            if status == .failed {
                return .failed
            }
        }
        // Try to move the file or folder.
        do {
            try fileManager.moveItem(at: sourcePath, to: destinationPath)
            print("Moved: \(sourcePath) to \(destinationPath)")
            return .success
        } catch {
            print("Error while moving the file." + error.localizedDescription)
            return .failed
        }
    }

    func deleteLastPathComponent(from path: URL) -> URL {
        return path.deletingLastPathComponent()
    }

    func createFolderPath(at path: URL) -> MoveResult {
        do {
            try fileManager.createDirectory(at: path, withIntermediateDirectories: true)
            return .success
        } catch {
            print("Error while creating directory" + error.localizedDescription)
            return .failed
        }
    }
}
