// swift-tools-version: 6.0
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
    ),
    Product.library(
      name: "HTTPClient",
      targets: ["HTTPClient"]
    ),
    Product.library(
      name: "SharedEntity",
      targets: ["SharedEntity"]
    )
  ],
  dependencies: [
    Package.Dependency.package(path: "../ToDoGardenUI"),
    Package.Dependency.package(url: "https://github.com/pointfreeco/sharing-grdb", from: "0.1.0")
  ],
  targets: [
    Target.target(
      name: "HTTPClientAPI"
    ),
    Target.target(
      name: "HTTPClient",
      dependencies: ["HTTPClientAPI"]
    ),
    Target.target(
      name: "TDFoundation",
      dependencies: [
        Target.Dependency.product(
          name: "SharingGRDB",
          package: "sharing-grdb"
        ),
        Target.Dependency.product(
          name: "ToDoGardenUIComponent",
          package: "ToDoGardenUI"
        ),
        "HTTPClientAPI"
      ]
    ),
    Target.target(
      name: "SharedEntity"
    ),
    Target.testTarget(
      name: "HTTPClientTests",
      dependencies: [
        "HTTPClientAPI",
        "HTTPClient"
      ]
    ),
    Target.testTarget(
      name: "CacheTests",
      dependencies: ["TDFoundation"]
    ),
    Target.testTarget(
      name: "InfiniteScrollHandlerTests",
      dependencies: ["TDFoundation"]
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
