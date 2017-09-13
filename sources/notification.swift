import CoreLocation
import Foundation

private let kNotificationName = "com.apple.iphonesimulator.simulateLocation"

func postNotification(for coordinate: CLLocationCoordinate2D, to simulators: [String]) {
    postNotification(with: [
        "simulateLocationLatitude": coordinate.latitude,
        "simulateLocationLongitude": coordinate.longitude,
        "simulateLocationDevices": simulators,
    ])
}

func postNotification(for fileURL: URL, to simulators: [String]) {
    postNotification(with: [
        "simulateLocationPath": fileURL.absoluteString,
        "simulateLocationDevices": simulators,
    ])
}

private func postNotification(with userInfo: [AnyHashable: Any]) {
    let notification = Notification(name: Notification.Name(rawValue: kNotificationName), object: nil,
                                    userInfo: userInfo)
    DistributedNotificationCenter.default().post(notification)
}
