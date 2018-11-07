import CoreLocation
import Foundation
import MapKit

func findLocation(from arguments: [String]) -> Result<CLLocationCoordinate2D> {
    if arguments.isEmpty {
        return .failure("No arguments passed for location search")
    }

    let query = arguments.joined(separator: " ")
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query

    let search = MKLocalSearch(request: request)
    let (response, error) = search.perform()

    guard let placemark = response?.mapItems.first?.placemark else {
        return .failure("No locations found for '\(query)'")
    }

    guard let coordinate = placemark.location?.coordinate else {
        return .failure("No coordinate found for '\(placemark.name ?? "")'")
    }

    if let error = error {
        return .failure(error.localizedDescription)
    }

    return .success(coordinate)
}

private extension MKLocalSearch {
    func perform() -> (Response?, Error?) {
        var result: (Response?, Error?)?

        self.start { response, error in
            result = (response, error)
        }

        while result == nil {
            RunLoop.main.run(until: Date(timeIntervalSinceNow: 1))
        }

        return result!
    }
}
