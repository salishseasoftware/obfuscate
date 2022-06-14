// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "obfuscate",
    platforms: [ .macOS(.v11) ],
    products: [
        .library(name: "Obfuscater", targets: ["Obfuscater"]),
        .executable(name: "obfuscate", targets: ["obfuscate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Obfuscater", dependencies: []),
        .testTarget(name: "ObfuscaterTests", dependencies: ["Obfuscater"]),
        .executableTarget(
            name: "obfuscate",
            dependencies: [
                "Obfuscater",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget( name: "obfuscateTests", dependencies: ["obfuscate"]),
    ]
)
