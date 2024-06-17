// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "TimerScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "TimerScene",
      targets: ["TimerScene"]
    )
  ],
  dependencies: [
    .package(path: "../ToDoGardenUI")
  ],
  targets: [
    .target(
      name: "TimerScene",
      dependencies: [
        "TimerSceneEntity",
        "TimerSceneApi",
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "TimerSceneApi"
    ),
    .target(
      name: "TimerSceneEntity"
    ),
    .testTarget(
      name: "TimerSceneTests",
      dependencies: ["TimerScene"]
    )
  ],
  swiftLanguageVersions: [.v6]
)
