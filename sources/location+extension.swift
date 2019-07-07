import CoreLocation

extension CLLocation {
    var isValid: Bool {
        return CLLocationCoordinate2DIsValid(self.coordinate)
            && !(self.coordinate.latitude == 0.0 && self.coordinate.longitude == 0.0)
    }
}
