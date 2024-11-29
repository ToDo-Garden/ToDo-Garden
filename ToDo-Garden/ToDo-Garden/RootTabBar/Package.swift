// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RootTabBar",
  platforms: [SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v15)],
  products: [
    Product.library(
      name: "RootTabBar",
      targets: ["RootTabBar"]
    )
  ],
  dependencies: [
    Package.Dependency.package(
      name: "ToDoGardenUI",
      path: "../ToDoGardenUI"
    ),
    Package.Dependency.package(
      name: "TDFoundation",
      path: "../TDFoundation"
    )
  ],
  targets: [
    Target.target(
      name: "RootTabBar",
      dependencies: [
        Target.Dependency.product(
          name: "ToDoGardenUIAPI",
          package: "ToDoGardenUI"
        ),
        Target.Dependency.product(
          name: "ToDoGardenUIResource",
          package: "ToDoGardenUI"
        ),
        Target.Dependency.product(
          name: "TDFoundation",
          package: "TDFoundation"
        )
      ]
    )
  ]
)

for target in package.targets {
  var swiftSettings = target.swiftSettings ?? []
  swiftSettings.append(
    SwiftSetting.enableExperimentalFeature("StrictConcurrency")
  )
  target.swiftSettings = swiftSettings
}
