// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TidesAndCurrentsClient",
    platforms: [
        .iOS(.v14)
        //        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Commons",
            targets: ["Commons"]
        ),
        .library(
            name: "TidesAndCurrentsClient",
            targets: ["TidesAndCurrentsClient"]
        ),
        .library(
            name: "TidesAndCurrentsClientLive",
            targets: ["TidesAndCurrentsClientLive"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // .package(path: "../Commons")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Commons",
            dependencies: []),
        .target(
            name: "TidesAndCurrentsClient",
            dependencies: ["Commons"]),
        .testTarget(
            name: "TidesAndCurrentsClientTests",
            dependencies: ["TidesAndCurrentsClient",
                           "TidesAndCurrentsClientLive"]),
        .target(
            name: "TidesAndCurrentsClientLive",
            dependencies: ["TidesAndCurrentsClient",
            ]),
    ]
)
