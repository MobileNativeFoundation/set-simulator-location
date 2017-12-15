import CoreLocation
import Foundation

var arguments = CommandLine.arguments.dropFirst()

enum DeviceMode
{
    case singleDevice
    case bootedDevices
}


// default
var deviceMode: DeviceMode = .bootedDevices

if arguments.contains("-d") {
    deviceMode = .singleDevice
}

guard let flag = arguments.popFirst() else {
    exitWithUsage()
}


let commands = [
    "-c": coordinate,
    "-q": findLocation
]

guard let command = commands[flag] else {
    exitWithUsage()
}

switch command(Array(arguments)) {
    case .success(let coordinate) where coordinate.isValid:
        do {
            switch deviceMode
            {
            case .bootedDevices:
                postNotification(for: coordinate, to: try getBootedSimulators())
            case .singleDevice:
                switch try getDeviceUdid(from: Array(arguments))
                {
                case .success(let simulator):
                    postNotification(for: coordinate, to: [simulator])
                case .failure(let error):
                    exitWithUsage(error: error)
                }

            }

            print("Setting location to \(coordinate.latitude) \(coordinate.longitude)")
        } catch let error as SimulatorFetchError {
            exitWithUsage(error: error.rawValue)
        }
    case .success(let coordinate):
        exitWithUsage(error: "Coordinate: \(coordinate) is invalid")
    case .failure(let error):
        exitWithUsage(error: error)
}
