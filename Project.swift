import ProjectDescription

let name = "Spyglass"

let dependencies: [TargetDependency] = [
    .package(product: "Vapor"),
    .package(product: "CustomDump"),
    .package(product: "ComposableArchitecture"),
    .package(product: "OutlineView")
]

let project = Project(
    name: name,
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    packages: [
        .remote(url: "https://github.com/vapor/vapor.git", requirement: .upToNextMajor(from: "4.0.0")),
        .remote(url: "https://github.com/pointfreeco/swift-custom-dump.git", requirement: .upToNextMajor(from: "0.5.0")),
        .remote(url: "https://github.com/pointfreeco/swift-composable-architecture.git", requirement: .upToNextMajor(from: "0.9.0")),
        .remote(url: "https://github.com/Sameesunkaria/OutlineView.git", requirement: .upToNextMajor(from: "1.0.0"))
    ],
    settings: .settings(
        configurations: [
            .debug(name: "Debug", xcconfig: Path("Config/SpyglassProject.xcconfig")),
            .release(name: "Release", xcconfig: Path("Config/SpyglassProject.xcconfig"))
        ]
    ),
    targets: [
        Target(
            name: name,
            platform: .macOS,
            product: .app,
            bundleId: "no.org.\(name)",
            deploymentTarget: .macOS(targetVersion: "12.1"),
            infoPlist: .default,
            sources: ["Source/**"],
            resources: ["Source/Resources/**"],
            entitlements: "Source/\(name)/\(name).entitlements",
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "DEVELOPMENT_ASSET_PATHS": ["Source/Resources"]
                ],
                configurations: [
                    .debug(name: "Debug", xcconfig: Path("Config/Spyglass.xcconfig")),
                    .release(name: "Release", xcconfig: Path("Config/Spyglass.xcconfig"))
                ]
            )
        ),
        Target(
            name: "\(name)Tests",
            platform: .macOS,
            product: .unitTests,
            bundleId: "no.org.\(name)Tests",
            deploymentTarget: .macOS(targetVersion: "12.1"),
            infoPlist: .default,
            sources: ["\(name)Tests/**"],
            resources: ["\(name)Tests/**",],
            dependencies: [.target(name: name)] + dependencies,
            settings: .settings(
                configurations: [
                    .debug(name: "Debug", xcconfig: Path("Config/SpyglassTests.xcconfig")),
                    .release(name: "Release", xcconfig: Path("Config/SpyglassTests.xcconfig"))
                ]
            )
        ),
        Target(
            name: "\(name)UITests",
            platform: .macOS,
            product: .uiTests,
            bundleId: "no.org.\(name)UITests",
            deploymentTarget: .macOS(targetVersion: "12.1"),
            infoPlist: .default,
            sources: ["\(name)UITests/**"],
            resources: ["\(name)UITests/**",],
            dependencies: [.target(name: name)] + dependencies,
            settings: .settings(
                configurations: [
                    .debug(name: "Debug", xcconfig: Path("Config/SpyglassUITests.xcconfig")),
                    .release(name: "Release", xcconfig: Path("Config/SpyglassUITests.xcconfig"))
                ]
            )
        )
    ]
)
