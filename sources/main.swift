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
        print("Setting location to \(coordinate.latitude) \(coordinate.longitude)")
        postNotification(for: coordinate)
    case .success(let coordinate):
        exitWithUsage(error: "Coordinate: \(coordinate) is invalid")
    case .failure(let error):
        exitWithUsage(error: error)
}
