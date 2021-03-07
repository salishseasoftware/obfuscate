// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "obfuscate",
    platforms: [ .macOS(.v11) ],
    products: [
        .library(name: "Obfuscator", targets: ["Obfuscator"]),
        .executable(name: "obfuscate", targets: ["obfuscate"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
    ],
    targets: [
        .target(name: "Obfuscator", dependencies: []),
        .testTarget(name: "ObfuscatorTests", dependencies: ["Obfuscator"]),
        .target(
            name: "obfuscate",
            dependencies: [
                "Obfuscator",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget( name: "obfuscateTests", dependencies: ["obfuscate"]),
    ]
)
