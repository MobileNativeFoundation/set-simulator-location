import Foundation

private let kBootedUDIDRegex = "^    [^(]*\\(([^\\)]*)\\) \\(Booted\\)$"

enum SimulatorFetchError: String, Error {
    case simctlFailed = "Running `simctl list` failed"
    case failedToReadOutput = "Failed to read output from simctl"
    case noBootedSimulators = "No simulators are currently booted"
}

func getBootedSimulators() throws -> [String] {
    let task = Process()
    task.launchPath = "/usr/bin/xcrun"
    task.arguments = ["simctl", "list", "devices"]

    let pipe = Pipe()
    task.standardOutput = pipe

    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    task.waitUntilExit()
    pipe.fileHandleForReading.closeFile()

    if task.terminationStatus != 0 {
        throw SimulatorFetchError.simctlFailed
    }

    guard let output = String(data: data, encoding: .utf8) else {
        throw SimulatorFetchError.failedToReadOutput
    }

    let nsString = output as NSString
    let regex = try! NSRegularExpression(pattern: kBootedUDIDRegex, options: .anchorsMatchLines)
    let matches = regex.matches(in: output, options: [],
                                range: NSRange(location: 0, length: nsString.length))

    if matches.isEmpty {
        throw SimulatorFetchError.noBootedSimulators
    }

    return matches.map { nsString.substring(with: $0.rangeAt(1)) }
}
