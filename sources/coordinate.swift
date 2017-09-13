import CoreLocation

func coordinate(from arguments: [String]) -> LocationSimulationData {
    if arguments.count != 2 {
        return .failure("Incorrect number of arguments, expected 2 got \(arguments.count)")
    }

    guard let latitude = arguments.first.flatMap(Double.init),
            let longitude = arguments.last.flatMap(Double.init) else
    {
        return .failure("Expected 2 numbers, got '\(arguments[0])' and '\(arguments[1])'")
    }

    return .coordinate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
}
