import Foundation

enum SimulatorFetchError: String, Error {
    case simctlFailed = "Running `simctl list` failed"
    case failedToReadOutput = "Failed to read output from simctl"
    case noBootedSimulators = "No simulators are currently booted"
}

func getBootedSimulators() throws -> [String] {
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
    let bootedIDs = devices
        .flatMap { $1 }
        .filter { $0["state"] == "Booted" }
        .flatMap { $0["udid"] }

    if bootedIDs.isEmpty {
        throw SimulatorFetchError.noBootedSimulators
    }

    return bootedIDs
}
