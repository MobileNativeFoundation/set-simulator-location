import CoreLocation

func location(from arguments: [String]) -> Result<CLLocation> {
    if arguments.count == 2 {
        guard let latitude = arguments.first.flatMap(Double.init),
            let longitude = arguments.last.flatMap(Double.init) else
        {
            return .failure("Expected 2 numbers, got '\(arguments[0])' and '\(arguments[1])'")
        }
        
        return .success(CLLocation(latitude: latitude, longitude: longitude))
    } else if arguments.count == 3 {
        guard let latitude = arguments.first.flatMap(Double.init),
            let longitude = Double(arguments[1]),
            let altitude = arguments.last.flatMap(Double.init) else
        {
            return .failure("Expected 3 numbers, got '\(arguments[0])', '\(arguments[1])' and '\(arguments[2])'")
        }

        return .success(
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                       altitude: altitude,
                       horizontalAccuracy: 0,
                       verticalAccuracy: 0,
                       course: 0,
                       speed: 0,
                       timestamp: Date()
            )
        )
    } else {
        return .failure("Incorrect number of arguments, expected 2 or 3 got \(arguments.count)")
    }
}
