import CoreLocation

extension CLLocationCoordinate2D {
    var isValid: Bool {
        return CLLocationCoordinate2DIsValid(self)
            && !(self.latitude == 0.0 && self.longitude == 0.0)
    }
}
