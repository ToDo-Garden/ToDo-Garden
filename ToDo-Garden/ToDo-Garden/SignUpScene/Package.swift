// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SignUpScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "SignUpSceneAPI",
      targets: ["SignUpSceneAPI"]
    ),
    .library(
      name: "SignUpSceneEntity",
      targets: ["SignUpSceneEntity"]
    ),
    .library(
      name: "SignUpScene",
      targets: ["SignUpScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI"),
    .package(path: "../TDUtility")
  ],
  targets: [
    .target(
      name: "SignUpSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "SignUpSceneEntity"
    ),
    .target(
      name: "SignUpScene",
      dependencies: [
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        "SignUpSceneAPI",
        "SignUpSceneEntity",
        .product(name: "TDUtility", package: "TDUtility"),
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    ),
    .testTarget(
      name: "SignUpSceneTests",
      dependencies: ["SignUpScene"]
    )
  ]
)
