import Foundation

var arguments = CommandLine.arguments.dropFirst()
let deviceUUID = try consumeArgument(flag: "-u", from: &arguments).map(createUUID)
let deviceName = consumeArgument(flag: "-s", from: &arguments)

guard let flag = arguments.popFirst() else {
    exitWithUsage()
}

let commands = [
    "-c": coordinate,
    "-q": findLocation,
]

guard let command = commands[flag] else {
    exitWithUsage()
}

switch command(Array(arguments)) {
    case .success(let coordinate) where coordinate.isValid:
        do {
            let bootedSimulators = try getBootedSimulators()
            let simulators =
                try deviceUUID.map { try getSimulators(with: $0, from: bootedSimulators) }
                ?? deviceName.map { try getSimulators(named: $0, from: bootedSimulators) }
                ?? bootedSimulators
            postNotification(for: coordinate, to: simulators.map { $0.udid.uuidString })
            print("Setting location to \(coordinate.latitude) \(coordinate.longitude)")
        } catch let error as SimulatorFetchError {
            exitWithUsage(error: error.description)
        }
    case .success(let coordinate):
        exitWithUsage(error: "Coordinate: \(coordinate) is invalid")
    case .failure(let error):
        exitWithUsage(error: error)
}
