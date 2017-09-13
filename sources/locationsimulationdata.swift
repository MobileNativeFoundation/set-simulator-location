import CoreLocation

enum LocationSimulationData {
    case coordinate(CLLocationCoordinate2D)
    case fileURL(URL)
    case failure(String)
}
