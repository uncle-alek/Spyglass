import ProjectDescription

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump.git", .upToNextMajor(from: "0.5.0")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .upToNextMajor(from: "0.9.0")),
        .package(url: "https://github.com/Sameesunkaria/OutlineView.git", .upToNextMajor(from: "1.0.0")),
    ],
    platforms: [.macOS]
)
