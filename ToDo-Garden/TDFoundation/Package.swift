// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TDFoundation",
  platforms: [SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v15)],
  products: [
    Product.library(
      name: "TDFoundation",
      targets: ["TDFoundation"]
    ),
    Product.library(
      name: "HTTPClientAPI",
      targets: ["HTTPClientAPI"]
    )
  ],
  dependencies: [
    Package.Dependency.package(path: "../ToDoGardenUI")
  ],
  targets: [
    Target.target(
      name: "HTTPClientAPI"
    ),
    Target.target(
      name: "TDFoundation",
      dependencies: [
        Target.Dependency.product(
          name: "ToDoGardenUIComponent",
          package: "ToDoGardenUI"
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
