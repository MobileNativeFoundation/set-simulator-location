import Foundation

enum SimulatorFetchError: String, Error {
    case simctlFailed = "Running `simctl list` failed"
    case failedToReadOutput = "Failed to read output from simctl"
    case noBootedSimulators = "No simulators are currently booted"
}

struct Simulator
{
    enum State : String
    {
        case shutdown = "Shutdown"
        case booted = "Booted"
    }

    var udid: String
    var name: String
    var state: State
}

func getDeviceUdid(name: String) throws -> Result<String>
{
    let simulators: [Simulator] = try getSimulators().filter { $0.name == name }

    guard let simulator = simulators.first else {
        return .failure("No simulators found by that name")
    }

    return .success(simulator.udid)
}

func getBootedSimulators() throws -> [String]
{
    let simulators = try getSimulators()
    let bootedSimulators = simulators.filter { $0.state == .booted }
                                    .map { $0.udid }

    return bootedSimulators
}


func getSimulators() throws -> [Simulator] {
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

    var simulators = [Simulator]()
    for topName in devices.keys
    {
        if let deviceTypes = devices[topName]
        {
            for typeDict in deviceTypes
            {
                guard let udid = typeDict["udid"],
                    let name = typeDict["name"],
                    let stateString = typeDict["state"],
                    let state = Simulator.State(rawValue: stateString) else {
                        continue
                }
                simulators.append(Simulator(udid: udid, name: name, state: state))
            }
        }
    }

    return simulators
}
