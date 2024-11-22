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
  targets: [
    Target.target(
      name: "RootTabBar"
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
