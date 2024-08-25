import Foundation

class CommandHelper {
    func parseArguments(rawArguments: String) -> [String] {
        var arguments = [String]()
        var currentArgument = ""
        var insideQuotes = false

        for char in rawArguments {
            if char == "\"" {
                insideQuotes.toggle()
            }
            else if char.isWhitespace && !insideQuotes && !currentArgument.isEmpty {
                arguments.append(currentArgument)
                currentArgument = ""
            }
            else {
                currentArgument.append(char)
            }
        }
        if !currentArgument.isEmpty {
            arguments.append(currentArgument)
        }
        return arguments
    }
}
