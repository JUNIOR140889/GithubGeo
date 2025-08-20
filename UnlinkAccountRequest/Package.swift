// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "UnlinkAccountRequest",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "UnlinkAccountRequest",
            targets: [
                "UnlinkAccountRequest",
                "UnlinkAccountRequestObjc"
            ]
        )
    ],
    dependencies: [
        .package(path: "../APIKit")
    ],
    targets: [
        .target(
            name: "UnlinkAccountRequest",
             dependencies: [
                "APIKit"
            ],
            path: "Sources/UnlinkAccountRequest"
        ),
        .target(
            name: "UnlinkAccountRequestObjc",
            path: "Sources/UnlinkAccountRequestObjc",
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "UnlinkAccountRequest_Tests",
            dependencies: ["UnlinkAccountRequest"],
            path: "Tests/UnlinkAccountRequest_Tests"
        )
    ]
)
