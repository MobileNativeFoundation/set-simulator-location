// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "set-simulator-location",
    products: [
        .executable(
            name: "set-simulator-location",
            targets: [
                "set-simulator-location"
            ]
        )
    ],
    targets: [
        .target(
            name: "set-simulator-location",
            path: "sources"
        ),
    ]
)
