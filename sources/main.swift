import Foundation

var arguments = CommandLine.arguments.dropFirst()
let deviceUUID = try consumeArgument(name: "-u", from: &arguments).map(createUUID)
let deviceName = consumeArgument(name: "-s", from: &arguments)

guard let flag = arguments.popFirst() else {
    exitWithUsage()
}

let commands = [
    "-c": location,
    "-q": findLocation,
]

guard let command = commands[flag] else {
    exitWithUsage()
}

switch command(Array(arguments)) {
    case .success(let location) where location.isValid:
        do {
            let bootedSimulators = try getBootedSimulators()
            let simulators =
                try deviceUUID.map { try getSimulators(with: $0, from: bootedSimulators) }
                ?? deviceName.map { try getSimulators(named: $0, from: bootedSimulators) }
                ?? bootedSimulators
            postNotification(for: location, to: simulators.map { $0.udid.uuidString })
            print("Setting location to \(location.coordinate.latitude) \(location.coordinate.longitude) \(location.altitude)")
        } catch let error as SimulatorFetchError {
            exitWithUsage(error: error.description)
        }
    case .success(let coordinate):
        exitWithUsage(error: "Coordinate: \(coordinate) is invalid")
    case .failure(let error):
        exitWithUsage(error: error)
}
