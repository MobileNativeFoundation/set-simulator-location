import CoreLocation
import Foundation

private let kNotificationName = "com.apple.iphonesimulator.simulateLocation"

func postNotification(for coordinate: CLLocationCoordinate2D) {
    let userInfo: [AnyHashable: Any] = [
        "simulateLocationLatitude": coordinate.latitude,
        "simulateLocationLongitude": coordinate.longitude,
    ]

    let notification = Notification(name: Notification.Name(rawValue: kNotificationName), object: nil,
                                    userInfo: userInfo)

    DistributedNotificationCenter.default().post(notification)
}
