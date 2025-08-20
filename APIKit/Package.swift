// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "APIKit",
    products: [
        .library(name: "APIKit", targets: ["APIKit"])
    ],
    targets: [
        .target(name: "APIKit", path: "Sources/APIKit")
    ]
)
