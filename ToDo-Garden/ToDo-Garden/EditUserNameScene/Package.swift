// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "EditUserNameScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "EditUserNameSceneAPI",
      targets: ["EditUserNameSceneAPI"]
    ),
    .library(
      name: "EditUserNameSceneEntity",
      targets: ["EditUserNameSceneEntity"]
    ),
    .library(
      name: "EditUserNameScene",
      targets: ["EditUserNameScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI")
  ],
  targets: [
    .target(
      name: "EditUserNameSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "EditUserNameSceneEntity"
    ),
    .target(
      name: "EditUserNameScene",
      dependencies: [
        "EditUserNameSceneAPI",
        "EditUserNameSceneEntity",
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    )
  ]
)
