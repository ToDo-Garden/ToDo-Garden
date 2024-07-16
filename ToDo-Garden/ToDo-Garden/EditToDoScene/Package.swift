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
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI")
  ],
  targets: [
    .target(
      name: "EditToDoSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "EditToDoSceneEntity"
    ),
    .target(
      name: "EditToDoScene",
      dependencies: [
        "EditToDoSceneAPI",
        "EditToDoSceneEntity",
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    ),
    .testTarget(
      name: "EditToDoSceneTests",
      dependencies: [
        "EditToDoScene"
      ]
    )
  ]
)
