import Foundation

func consumeArgument(flag: String, from arguments: inout ArraySlice<String>) -> String? {
    if let argumentIndex = arguments.index(of: flag) {
        let value = arguments.suffix(from: argumentIndex).dropFirst().joined(separator: " ")
        if value.isEmpty {
            exitWithUsage()
        }

        arguments = arguments.prefix(upTo: argumentIndex)
        return value
    }

    return nil
}

func createUUID(from string: String) throws -> UUID {
    if let uuid = UUID(uuidString: string) {
        return uuid
    }

    throw CommandLineError.invalidUUID(string: string)
}
