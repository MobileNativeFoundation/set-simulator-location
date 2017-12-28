enum SimulatorFetchError: Error, CustomStringConvertible {
    case simctlFailed
    case failedToReadOutput
    case noBootedSimulators
    case noMatchingSimulators(name: String)

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
        }
    }
}
