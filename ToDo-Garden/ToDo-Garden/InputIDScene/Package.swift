// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "InputIDScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "InputIDSceneAPI",
      targets: ["InputIDSceneAPI"]
    ),
    .library(
      name: "InputIDSceneEntity",
      targets: ["InputIDSceneEntity"]
    ),
    .library(
      name: "InputIDScene",
      targets: ["InputIDScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI"),
    .package(path: "../TDUtility")
  ],
  targets: [
    .target(
      name: "InputIDSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "InputIDSceneEntity"
    ),
    .target(
      name: "InputIDScene",
      dependencies: [
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        "InputIDSceneAPI",
        "InputIDSceneEntity",
        .product(name: "TDUtility", package: "TDUtility"),
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    ),
    .testTarget(
      name: "InputIDSceneTests",
      dependencies: ["InputIDScene"]
    )
  ]
)
