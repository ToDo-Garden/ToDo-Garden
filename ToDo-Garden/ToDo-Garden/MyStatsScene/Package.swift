// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MyStatsScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "MyStatsSceneAPI",
      targets: ["MyStatsSceneAPI"]
    ),
    .library(
      name: "MyStatsSceneEntity",
      targets: ["MyStatsSceneEntity"]
    ),
    .library(
      name: "MyStatsScene",
      targets: ["MyStatsScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI"),
    .package(path: "../TDUtility")
  ],
  targets: [
    .target(
      name: "MyStatsSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "MyStatsSceneEntity"
    ),
    .target(
      name: "MyStatsScene",
      dependencies: [
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        "MyStatsSceneAPI",
        "MyStatsSceneEntity",
        .product(name: "TDUtility", package: "TDUtility"),
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    ),
    .testTarget(
      name: "MyStatsSceneTests",
      dependencies: ["MyStatsScene"]
    )
  ]
)
