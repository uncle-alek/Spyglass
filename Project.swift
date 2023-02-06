import ProjectDescription
//import ProjectDescriptionHelpers

let name = "Spyglass"
let dependencies: [TargetDependency] = [
    .package(product: "Vapor"),
    .package(product: "CustomDump"),
    .package(product: "ComposableArchitecture"),
    .package(product: "OutlineView")
]

//let dependenciesExternal: [TargetDependency] = [
//    .external(name: "Vapor"),
//    .external(name: "CustomDump"),
//    .external(name: "ComposableArchitecture"),
//    .external(name: "OutlineView")
//]

let project = Project(
        name: name,
        packages: [
            .remote(url: "https://github.com/vapor/vapor.git", requirement: .upToNextMajor(from: "4.0.0")),
            .remote(url: "https://github.com/pointfreeco/swift-custom-dump.git", requirement: .upToNextMajor(from: "0.5.0")),
            .remote(url: "https://github.com/pointfreeco/swift-composable-architecture.git", requirement: .upToNextMajor(from: "0.9.0")),
            .remote(url: "https://github.com/Sameesunkaria/OutlineView.git", requirement: .upToNextMajor(from: "1.0.0"))
        ],
        targets: [
            Target(
                name: name,
                platform: .macOS,
                product: .app,
                bundleId: "io.tuist.\(name)",
                deploymentTarget: .macOS(targetVersion: "12.1"),
                infoPlist: .default,
                sources: ["Source/**"],
                resources: ["Source/Resources/**"],
                dependencies: dependencies
            ),
            Target(
                name: "\(name)Tests",
                platform: .macOS,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                deploymentTarget: .macOS(targetVersion: "12.1"),
                infoPlist: .default,
                sources: ["\(name)Tests/**"],
                resources: ["\(name)Tests/**",],
                dependencies: [.target(name: name)]
            ),
            Target(
                name: "\(name)UITests",
                platform: .macOS,
                product: .uiTests,
                bundleId: "io.tuist.\(name)UITests",
                deploymentTarget: .macOS(targetVersion: "12.1"),
                infoPlist: .default,
                sources: ["\(name)UITests/**"],
                resources: ["\(name)UITests/**",],
                dependencies: [.target(name: name)]
            )
        ]
    )
