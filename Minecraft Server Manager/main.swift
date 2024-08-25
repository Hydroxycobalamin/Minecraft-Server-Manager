import Foundation

print("Initializing Program")
AppDataManager.shared.loadData()
if let data = AppDataManager.shared.masterData {
    print("Configuration loaded. \nPlugins: \(data.plugins.count) Server: \(data.servers.count)")
}

print("Program initialized.")
print("You have the following options:")
for options in OptionType.allCases {
    print(options.getDescription(for: options))
}

if let input = readLine() {
    let arguments = CommandHelper().parseArguments(rawArguments: input)
    if let selectedOption = OptionType(rawValue: String(arguments[0])) {
        switch selectedOption {
            // example: addserver servername version path 
        case .addserver:
            if arguments.count == 4 {
                AddServerHelper().addServer(as: String(arguments[1]), with: String(arguments[2]), on: String(arguments[3]))
            } else {
                print("Wrong amount of arguments. You need 4.")
            }
        case .addplugintoserver:
            if arguments.count == 3 {
                SymlinkHelper().addPluginToServer(serverName: String(arguments[1]), pluginName: String(arguments[2]))
            }
        case .addplugin:
            // example: addplugin citizens jenkins
            if arguments.count == 3 {
                AddPluginHelper().addPlugin(as: String(arguments[1]), from: String(arguments[2]))
            } else {
                print("Wrong amount of arguments, input '" + input + "'")
            }
        case .addworld:
            if arguments.count == 3 {
                AddWorldHelper().addWorld(version: String(arguments[1]), worldPath: String(arguments[2]))
            }
        case .update:
            print("Update started")
        //TODO: Update Handling
            /*
            if UpdateHelper().updateToLatest() == .success {
            } else {}*/

        }
    } else {
        //TODO: ErrorHandling
    }
}

print("Done.")
