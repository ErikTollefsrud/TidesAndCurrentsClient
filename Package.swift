// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TidesAndCurrentsClient",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TidesAndCurrentsClient",
            type: .dynamic,
            targets: ["TidesAndCurrentsClient"]),
        .library(
            name: "TidesAndCurrentsClientLive",
            type: .dynamic,
            targets: ["TidesAndCurrentsClientLive"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.8.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TidesAndCurrentsClient",
            dependencies: [
                //.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .testTarget(
            name: "TidesAndCurrentsClientTests",
            dependencies: ["TidesAndCurrentsClient",
            "TidesAndCurrentsClientLive"]),
        
        .target(
            name: "TidesAndCurrentsClientLive",
            dependencies: ["TidesAndCurrentsClient",
                           //.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
    ]
)
