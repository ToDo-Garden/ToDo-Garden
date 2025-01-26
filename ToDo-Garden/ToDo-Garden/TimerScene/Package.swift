// swift-tools-version: 5.10
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
    .package(path: "../ToDoGardenUI"),
    .package(path: "../TDFoundation")
  ],
  targets: [
    .target(
      name: "TimerScene",
      dependencies: [
        "TimerSceneEntity",
        "TimerSceneAPI",
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "TDFoundation", package: "TDFoundation")
      ],
      swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
    ),
    .target(
      name: "TimerSceneAPI",
      dependencies: [.product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")]
    ),
    .target(name: "TimerSceneEntity"),
    .testTarget(
      name: "TimerSceneTests",
      dependencies: ["TimerScene"]
    )
  ]
)
