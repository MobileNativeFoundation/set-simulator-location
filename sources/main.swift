import CoreLocation
import Foundation

var arguments = CommandLine.arguments.dropFirst()
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
            postNotification(for: coordinate, to: try getBootedSimulators())
            print("Setting location to \(coordinate.latitude) \(coordinate.longitude)")
        } catch let error as SimulatorFetchError {
            exitWithUsage(error: error.rawValue)
        }
    case .success(let coordinate):
        exitWithUsage(error: "Coordinate: \(coordinate) is invalid")
    case .failure(let error):
        exitWithUsage(error: error)
}
