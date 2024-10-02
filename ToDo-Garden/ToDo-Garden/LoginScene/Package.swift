// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LoginScene",
  products: [
    .library(
      name: "LoginSceneAPI",
      targets: ["LoginSceneAPI"]
    ),
    .library(
      name: "LoginSceneEntity",
      targets: ["LoginSceneEntity"]
    ),
    .library(
      name: "LoginScene",
      targets: ["LoginScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI"),
    .package(path: "../TDUtility")
  ],
  targets: [
    .target(
      name: "LoginSceneAPI"
    ),
    .target(
      name: "LoginSceneEntity"
    ),
    .target(
      name: "LoginScene",
      dependencies: [
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        "LoginSceneAPI",
        "LoginSceneEntity",
        .product(name: "TDUtility", package: "TDUtility"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    ),
    .testTarget(
      name: "LoginSceneTests",
      dependencies: ["LoginScene"])
  ]
)
