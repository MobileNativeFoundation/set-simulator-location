import Foundation

func consumeArgument(name: String, from arguments: inout ArraySlice<String>) -> String? {
    guard let argumentIndex = arguments.firstIndex(of: name) else {
        return nil
    }

    let value = arguments.suffix(from: argumentIndex).dropFirst().joined(separator: " ")
    if value.isEmpty {
        exitWithUsage()
    }

    arguments = arguments.prefix(upTo: argumentIndex)
    return value
}

func createUUID(from string: String) throws -> UUID {
    if let uuid = UUID(uuidString: string) {
        return uuid
    }

    throw CommandLineError.invalidUUID(string: string)
}
