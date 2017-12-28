import Foundation

struct Simulator {
    fileprivate enum State: String {
        case shutdown = "Shutdown"
        case booted = "Booted"
    }

    fileprivate var state: State
    let name: String
    let udid: String

    fileprivate init?(dictionary: [String: String]) {
        guard let state = dictionary["state"].flatMap(State.init), let udid = dictionary["udid"],
            let name = dictionary["name"] else
        {
            return nil
        }

        self.name = name
        self.state = state
        self.udid = udid
    }
}

func getSimulators(named name: String, from simulators: [Simulator]) throws -> [Simulator] {
    let matchingSimulators = simulators.filter { $0.name.lowercased() == name.lowercased() }
    if matchingSimulators.isEmpty {
        throw SimulatorFetchError.noMatchingSimulators(name: name)
    }

    return matchingSimulators
}

func getBootedSimulators() throws -> [Simulator] {
    let task = Process()
    task.launchPath = "/usr/bin/xcrun"
    task.arguments = ["simctl", "list", "-j", "devices"]

    let pipe = Pipe()
    task.standardOutput = pipe

    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    task.waitUntilExit()
    pipe.fileHandleForReading.closeFile()

    if task.terminationStatus != 0 {
        throw SimulatorFetchError.simctlFailed
    }

    guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
        throw SimulatorFetchError.failedToReadOutput
    }

    let devices = json["devices"] as? [String: [[String: String]]] ?? [:]
    let bootedSimulators = devices.flatMap { $1 }
        .flatMap(Simulator.init)
        .filter { $0.state == .booted }

    if bootedSimulators.isEmpty {
        throw SimulatorFetchError.noBootedSimulators
    }

    return bootedSimulators
}
