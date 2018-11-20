import Foundation

enum CommandLineError: Error, CustomStringConvertible {
    case invalidUUID(string: String)

    var description: String {
        switch self {
        case .invalidUUID(let string):
            return "The UUID '\(string)' is invalid"
        }
    }
}

enum SimulatorFetchError: Error, CustomStringConvertible {
    case simctlFailed
    case failedToReadOutput
    case noBootedSimulators
    case noMatchingSimulators(name: String)
    case noMatchingUDID(udid: UUID)

    var description: String {
        switch self {
        case .simctlFailed:
            return "Running `simctl list` failed"
        case .failedToReadOutput:
            return "Failed to read output from simctl"
        case .noBootedSimulators:
            return "No simulators are currently booted"
        case .noMatchingSimulators(let name):
            return "No booted simulators named '\(name)'"
        case .noMatchingUDID(let udid):
            return "No booted simulators with udid: \(udid.uuidString)"
        }
    }
}
