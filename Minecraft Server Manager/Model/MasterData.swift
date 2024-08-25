import Foundation

struct MasterData: Codable {
    var servers: [Server]
    var plugins: [Plugin]
    var worlds: [World]
}

extension MasterData {
    var getJsonData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            return try encoder.encode(self)
        } catch {
            print("Error while encoding MasterData\n" + error.localizedDescription)
            return nil
        }

    }
}
