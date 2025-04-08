// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "EditToDoScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "EditToDoSceneAPI",
      targets: ["EditToDoSceneAPI"]
    ),
    .library(
      name: "EditToDoSceneEntity",
      targets: ["EditToDoSceneEntity"]
    ),
    .library(
      name: "EditToDoScene",
      targets: ["EditToDoScene"]
    )
  ],
  dependencies: [
    .package(name: "TDUtility", path: "../TDUtility"),
    .package(name: "TDFoundation", path: "../TDFoundation"),
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI")
  ],
  targets: [
    .target(
      name: "EditToDoSceneAPI",
      dependencies: [
        "EditToDoSceneEntity",
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "TDFoundation", package: "TDFoundation")
      ]
    ),
    .target(
      name: "EditToDoSceneEntity",
      dependencies: [
        .product(name: "SharedEntity", package: "TDFoundation"),
        .product(name: "TDFoundation", package: "TDFoundation")
      ]
    ),
    .target(
      name: "EditToDoScene",
      dependencies: [
        "EditToDoSceneAPI",
        "EditToDoSceneEntity",
        .product(name: "HTTPClient", package: "TDFoundation"),
        .product(name: "TDFoundation", package: "TDFoundation"),
        .product(name: "TDUtility", package: "TDUtility"),
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    ),
    .testTarget(
      name: "EditToDoSceneTests",
      dependencies: [
        "EditToDoScene",
        "EditToDoSceneEntity"
      ]
    )
  ]
)
