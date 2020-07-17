import CoreLocation
import Foundation

private let kNotificationName = "com.apple.iphonesimulator.simulateLocation"

func postNotification(for coordinate: CLLocationCoordinate2D?, to simulators: [String]) {
    var userInfo: [AnyHashable: Any] = [
        "simulateLocationDevices": simulators,
    ]

    if let coordinate = coordinate {
        userInfo["simulateLocationLatitude"] = coordinate.latitude
        userInfo["simulateLocationLongitude"] = coordinate.longitude
    }

    let notification = Notification(name: Notification.Name(rawValue: kNotificationName), object: nil,
                                    userInfo: userInfo)

    DistributedNotificationCenter.default().post(notification)
}
