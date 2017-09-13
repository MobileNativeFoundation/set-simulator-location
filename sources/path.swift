import Foundation

func path(from arguments: [String]) -> LocationSimulationData {
    guard let url = arguments.first.map({ URL(fileURLWithPath: $0) }) else {
        return .failure("No file path passed")
    }

    do {
        _ = try url.checkResourceIsReachable()
        return .fileURL(url)
    } catch {
        return .failure("'\(url.path)' is not reachable")
    }
}
