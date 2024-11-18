// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SearchGardenScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "SearchGardenSceneAPI",
      targets: ["SearchGardenSceneAPI"]
    ),
    .library(
      name: "SearchGardenSceneEntity",
      targets: ["SearchGardenSceneEntity"]
    ),
    .library(
      name: "SearchGardenSceneScene",
      targets: ["SearchGardenScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI"),
    .package(path: "../TDUtility")
  ],
  targets: [
    .target(
      name: "SearchGardenSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "SearchGardenSceneEntity"
    ),
    .target(
      name: "SearchGardenScene",
      dependencies: [
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        "SearchGardenSceneAPI",
        "SearchGardenSceneEntity",
        .product(name: "TDUtility", package: "TDUtility"),
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    ),
    .testTarget(
      name: "SearchGardenSceneTests",
      dependencies: ["SearchGardenScene"]
    )
  ]
)
