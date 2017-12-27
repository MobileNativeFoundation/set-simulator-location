import CoreLocation
import Foundation

var arguments = CommandLine.arguments.dropFirst()

var deviceName: String?
if let argumentIndex = arguments.index(of: "-s") {
    let device = arguments.suffix(from: argumentIndex).dropFirst().joined(separator: " ")
    if device.isEmpty {
        exitWithUsage()
    } else {
        deviceName = device
    }

    arguments = arguments.prefix(upTo: argumentIndex)
}

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
            let simulators = try deviceName.map { try getSimulators(named: $0, from: bootedSimulators) }
                ?? bootedSimulators
            postNotification(for: coordinate, to: simulators.map { $0.udid })
            print("Setting location to \(coordinate.latitude) \(coordinate.longitude)")
        } catch let error as SimulatorFetchError {
            exitWithUsage(error: error.description)
        }
    case .success(let coordinate):
        exitWithUsage(error: "Coordinate: \(coordinate) is invalid")
    case .failure(let error):
        exitWithUsage(error: error)
}
