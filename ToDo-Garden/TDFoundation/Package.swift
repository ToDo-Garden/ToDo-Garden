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
  targets: [
    Target.target(
      name: "TDFoundation"
    ),
    Target.target(
      name: "HTTPClientAPI"
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
