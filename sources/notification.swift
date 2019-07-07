import CoreLocation
import Foundation

private let kNotificationName = "com.apple.iphonesimulator.simulateLocation"

func postNotification(for location: CLLocation, to simulators: [String]) {
    let userInfo: [AnyHashable: Any] = [
        "simulateLocationLatitude": location.coordinate.latitude,
        "simulateLocationLongitude": location.coordinate.longitude,
        "simulateLocationAltitude": location.altitude,
        "simulateLocationDevices": simulators,
    ]

    let notification = Notification(name: Notification.Name(rawValue: kNotificationName), object: nil,
                                    userInfo: userInfo)

    DistributedNotificationCenter.default().post(notification)
}
